//
//  AddRecipeViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit


class AddRecipeViewController: ShiftableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var unitPickerView: UIPickerView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextView: UITextField!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var ingredientsListTableView: UITableView!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        ingredientsListTableView.delegate = self
        ingredientsListTableView.dataSource = self
        
        titleTextField.delegate = self
        quantityTextField.delegate = self
        ingredientTextField.delegate = self
        directionsTextView.delegate = self
        
        unitTextView.inputView = unitPickerView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let recipe = recipe {
            titleTextField.text = recipe.title
            directionsTextView.text = recipe.directions
        }
        ingredientsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let recipe = recipe, recipe.title == "" || recipe.directions == "" else { return }
        RecipeController.shared.delete(recipe: recipe)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func addIngredientButtonTapped(_ sender: UIButton) {
        if let recipe = recipe {
            guard let name = ingredientTextField.text, ingredientTextField.text != nil,
                let quantityString = quantityTextField.text, let quantity = Int16(quantityString), let unit = unitTextView.text, unit != "" else { return }
            IngredientController.shared.addIngredientWith(name: name, quantity: quantity, unit: unit, recipe: recipe)
            view.resignFirstResponder()
            ingredientsTableView.reloadData()
            ingredientTextField.text = ""
            unitTextView.text = ""
            quantityTextField.text = ""
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, titleTextField.text != "",
            let directions = directionsTextView.text, directionsTextView.text != "" else { return }
        if let recipe = recipe {
            RecipeController.shared.update(recipe: recipe, with: title, directions: directions)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text != "" || directionsTextView.text != "" {
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
        if tableView == ingredientsTableView {
        let ingredients = recipe?.ingredients?.count
        return ingredients ?? 0
        } else if tableView == ingredientsListTableView {
            return self.ingredientsList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == ingredientsTableView {
            let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
            if let recipe = recipe {
                guard let ingredients = recipe.ingredients?.array as? [Ingredient] else { return UITableViewCell() }
                let ingredient = ingredients[indexPath.row]
                cell.textLabel?.text = "\(ingredient.quantity) \(ingredient.unit ?? "*")"
                cell.detailTextLabel?.text = ingredient.name
            }
            return cell
        } else if tableView == ingredientsListTableView {
            let cell = ingredientsListTableView.dequeueReusableCell(withIdentifier: "ingredientsListCell", for: indexPath)
            let ingredient = ingredientsList[indexPath.row]
            cell.textLabel?.text = ingredient
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let recipe = recipe,
                let ingredients = recipe.ingredients?.array as? [Ingredient] else { return }
            let ingredient = ingredients[indexPath.row]
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this ingredient? You can't undo this process.", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .cancel, handler: { (_) in
                IngredientController.shared.delete(ingredient: ingredient)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            let no = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true, completion: nil)
        }
    }
}


extension AddRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    static let units = [UnitVolume.cups, .pints, .tablespoons, .teaspoons, .quarts]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var abrvs: [String] = []
        for unit in AddRecipeViewController.units {
            let abrv = unit.symbol
            abrvs.append(abrv)
        }
        return abrvs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AddRecipeViewController.units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let indexPath = unitPickerView.selectedRow(inComponent: component)
        let name = AddRecipeViewController.units[indexPath].symbol
        view.endEditing(true)
        unitTextView.text = name
    }
    
}
