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
    @IBOutlet weak var directionsTextView: UITextView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directionsTextView.backgroundColor = UIColor.outsidePlate
        ingredientsListTableView.delegate = self
        ingredientsListTableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        ingredientsListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = recipe else { return 0 }
        if let ingredients = recipe.ingredients?.array as? [Ingredient] {
            return ingredients.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsListTableView.dequeueReusableCell(withIdentifier: "ingredientListCell", for: indexPath)
        guard let recipe = recipe else { return UITableViewCell() }
        if let ingredients = recipe.ingredients?.array as? [Ingredient] {
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.outsidePlate.withAlphaComponent(0.8)
            } else {
                cell.backgroundColor = UIColor.outsidePlate.withAlphaComponent(0.5)
            }
            
            let ingredient = ingredients[indexPath.row]
            cell.textLabel?.text = "\(ingredient.quantity) \(ingredient.unit ?? "*")"
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.detailTextLabel?.text = ingredient.name
            cell.detailTextLabel?.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func updateViews() {
        guard let recipe = recipe else { return }
        titleLabel.text = recipe.title
        directionsTextView.text = recipe.directions
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditRecipe" {
            guard let detailVC = segue.destination as? AddRecipeViewController else { return }
            guard let recipe = recipe else { return }
            detailVC.recipe = recipe
        }
    }
    
}
