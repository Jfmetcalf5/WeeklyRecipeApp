//
//  RecipeInfoViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/18/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class RecipeInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsListTableView: UITableView!
    @IBOutlet weak var directionsLabel: UILabel!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsListTableView.delegate = self
        ingredientsListTableView.dataSource = self
        updateViews()
        ingredientsListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ingredients = recipe?.ingredients?.array as? [Ingredient] {
            return ingredients.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsListTableView.dequeueReusableCell(withIdentifier: "ingredientListCell", for: indexPath)
        if let ingredients = recipe?.ingredients?.array as? [Ingredient] {
            let ingredient = ingredients[indexPath.row]
            cell.textLabel?.text = "\(ingredient.quantity) \(ingredient.unit ?? "*")"
            cell.detailTextLabel?.text = ingredient.name
        }
        
        return cell
    }
    
    func updateViews() {
        guard let recipe = recipe else { return }
        titleLabel.text = recipe.title
        directionsLabel.text = recipe.directions
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
