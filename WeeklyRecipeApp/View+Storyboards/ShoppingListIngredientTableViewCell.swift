//
//  ShoppingListIngredientTableViewCell.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/27/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

protocol ShoppingListTableViewControllerDelegate: class {
    func checkBoxButtonTapped(sender: ShoppingListIngredientTableViewCell)
}

class ShoppingListIngredientTableViewCell: UITableViewCell {
    
    weak var delegate: ShoppingListTableViewControllerDelegate?
    
    var ingredient: Ingredient? {
        didSet {
           updateCellViews()
        }
    }
    
    @IBOutlet weak var quantityUnitLabel: UILabel!
    @IBOutlet weak var IngredientNameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        if let delegate = delegate {
        delegate.checkBoxButtonTapped(sender: self)
        }
    }
    
    func updateCellViews() {
        guard let ingredient = ingredient else { return }
        quantityUnitLabel.text = "\(ingredient.quantity) \(ingredient.unit ?? "")"
        IngredientNameLabel.text = ingredient.name
        
        if ingredient.isChecked == false {
            checkBoxButton.setImage(#imageLiteral(resourceName: "EmptyBox"), for: .normal)
        } else {
            checkBoxButton.setImage(#imageLiteral(resourceName: "CheckedBox"), for: .normal)
        }
    }
}
