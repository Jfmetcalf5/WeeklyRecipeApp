//
//  ShoppingListIngredientTableViewCell.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/27/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class ShoppingListIngredientTableViewCell: UITableViewCell {
    
    var ingredient: Ingredient? {
        didSet {
           updateCellViews()
        }
    }
    
    @IBOutlet weak var quantityUnitLabel: UILabel!
    @IBOutlet weak var IngredientNameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    func updateCellViews() {
        guard let ingredient = ingredient else { return }
//        let quantityString = String(ingredient.quantity)
//        if quantityString.count > something
        quantityUnitLabel.text = "\(ingredient.quantity) \(ingredient.unit ?? "")"
        IngredientNameLabel.text = ingredient.name
    }
}
