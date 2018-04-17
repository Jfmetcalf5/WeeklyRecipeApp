//
//  AddRecipeViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
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

        titleTextField.delegate = self
        quantityTextField.delegate = self
        ingredientTextField.delegate = self
        directionsTextView.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let recipe = recipe {
            titleTextField.text = recipe.title
            directionsTextView.text = recipe.directions
        }
        ingredientsTableView.reloadData()
    }
    
    @IBAction func addIngredientButtonTapped(_ sender: UIButton) {
        if let recipe = recipe {
            guard let name = ingredientTextField.text, ingredientTextField.text != nil,
                let quantityString = quantityTextField.text, let quantity = Int16(quantityString) else { return }
            IngredientController.shared.addIngredientWith(name: name, quantity: quantity, recipe: recipe)
            view.resignFirstResponder()
            ingredientsTableView.reloadData()
            ingredientTextField.text = ""
            quantityTextField.text = ""
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, titleTextField.text != "",
            let directions = directionsTextView.text, directionsTextView.text != "" else {
                let alert = UIAlertController(title: "Missing Information", message: "Please make sure you enter all the information", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil); return }
        
        if let recipe = recipe {
            RecipeController.shared.update(recipe: recipe, with: title, directions: directions)
        } else {
            RecipeController.shared.addRecipeWith(title: title, directions: directions)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text == "" || directionsTextView.text == "", recipe == recipe {
            let alert = UIAlertController(title: "Continue?", message: "If you to go back, all work will be lost. Would you like to proceed?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { (yes) in
                if let recipe = self.recipe {
                RecipeController.shared.delete(recipe: recipe)
                self.navigationController?.popViewController(animated: true)
                }
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
        let ingredients = recipe?.ingredients?.count
        return ingredients ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        if let recipe = recipe {
            guard let ingredients = recipe.ingredients?.array as? [Ingredient] else { return UITableViewCell() }
            let ingredient = ingredients[indexPath.row]
            cell.textLabel?.text = "\(ingredient.quantity)"
            cell.detailTextLabel?.text = ingredient.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = RecipeController.shared.recipes[indexPath.row]
            
            RecipeController.shared.delete(recipe: recipe)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
