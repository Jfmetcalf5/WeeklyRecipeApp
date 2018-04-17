//
//  AddRecipeViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
    
    @IBAction func addIngredientButtonTapped(_ sender: UIButton) {
        guard let name = ingredientTextField.text, ingredientTextField.text != nil,
            let quantityString = quantityTextField.text, let quantity = Int16(quantityString) else { return }
        if let recipe = recipe {            
            IngredientController.shared.addIngredientWith(name: name, quantity: quantity, recipe: recipe)
            view.resignFirstResponder()
            quantityTextField.text = ""
            ingredientTextField.text = ""
            ingredientsTableView.reloadData()
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, titleTextField.text != nil,
            let directions = directionsTextView.text, directionsTextView.text != nil, let ingredientsOrderedSet = recipe?.ingredients,
            let ingredients = ingredientsOrderedSet.array as? [Ingredient] else { return }
        
        if let recipe = recipe {
            RecipeController.shared.update(recipe: recipe, with: title, ingredients: ingredients, directions: directions)
        } else {
            RecipeController.shared.addRecipeWith(title: title, ingredients: ingredients, directions: directions)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text != "" || ingredientTextField.text != "" {
            let alert = UIAlertController(title: "Continue?", message: "If you to go back, all work will be lost. Would you like to proceed?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { (yes) in
                self.navigationController?.popViewController(animated: true)
            }
            let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            
            present(alert, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Ingredients Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recipe = recipe {
            guard let ingredientsOrderedSet = recipe.ingredients,
                let ingredients = ingredientsOrderedSet.array as? [Ingredient] else { return 0 }
            return ingredients.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        if let recipe = recipe {
        
        guard let ingredientsOrderedSet = recipe.ingredients,
            let ingredients = ingredientsOrderedSet.array as? [Ingredient] else { return UITableViewCell() }
        
        let ingredient = ingredients[indexPath.row]
        
        cell.textLabel?.text = "\(ingredient.quantity)"
        cell.detailTextLabel?.text = ingredient.name
        
        return cell
        } else {
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = RecipeController.shared.recipes[indexPath.row]
            
            RecipeController.shared.delete(recipe: recipe)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
