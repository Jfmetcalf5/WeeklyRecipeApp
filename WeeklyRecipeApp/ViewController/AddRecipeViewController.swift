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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
    
    @IBAction func addIngredientButtonTapped(_ sender: UIButton) {
        guard let name = ingredientTextField.text, ingredientTextField.text != nil else { return }
        IngredientController.shared.addIngredientWith(name: name)
        view.resignFirstResponder()
        ingredientsTableView.reloadData()
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, titleTextField.text != nil,
            let directions = directionsTextView.text, directionsTextView.text != nil else { return }
        
        if quantityTextField.text == "" {
            let quantity = String(1)
        }
//        let recipe = Recipe(title: title, ingredients: <#T##[Ingredient]#>, directions: directions)
    }
    
    
    //MARK: - Ingredients Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientController.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        let ingredient = IngredientController.shared.ingredients[indexPath.row]
        
        cell.detailTextLabel?.text = ingredient.name
        quantityTextField.text = ""
        ingredientTextField.text = ""
        
        return cell
    }
    
}
