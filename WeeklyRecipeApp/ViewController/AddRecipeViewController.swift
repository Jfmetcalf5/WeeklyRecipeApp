//
//  AddRecipeViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit


class AddRecipeViewController: ShiftableViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var unitPickerView: UIPickerView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextView: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var ingredientsListTableView: UITableView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var recipe: Recipe?
    
    var ingredientsList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ingredientsList = IngredientsListController.shared.fetchIngredients()
        self.ingredientsList = ingredientsList
        
        setupSearchBar()
        
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        
        ingredientsListTableView.delegate = self
        ingredientsListTableView.dataSource = self
        ingredientsListTableView.isHidden = true
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        titleTextField.delegate = self
        quantityTextField.delegate = self
        directionsTextView.delegate = self
        
        unitTextView.inputAccessoryView = unitPickerView
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
    
    @IBAction func dismissKeyboard(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    //MARK: - Ingredient Search Bar Function
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ingredientsListTableView.isHidden = false
        filterContent(searchText: self.searchBar.text!)
        if searchBar.text == "" {
            ingredientsListTableView.isHidden = true
        }
    }
    
    func filterContent(searchText: String) {
        let searchedIngredients = IngredientsListController.shared.fetchIngredientsWithSearchTerm(string: searchText)
        ingredientsList = searchedIngredients
        ingredientsListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        ingredientsListTableView.isHidden = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //MARK: - Buttons Tapped Functions
    
    @IBAction func addIngredientButtonTapped(_ sender: UIButton) {
        if let recipe = recipe {
            guard let name = searchBar.text, name != "",
                let quantityString = quantityTextField.text, let quantity = Int16(quantityString), let unit = unitTextView.text, unit != "" else { return }
            IngredientController.shared.addIngredientWith(name: name, quantity: quantity, unit: unit, recipe: recipe)
            view.resignFirstResponder()
            ingredientsTableView.reloadData()
            searchBar.text = ""
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
            let alert = UIAlertController(title: "Continue?", message: "If you have made changes, all you changes will be lost. Would you like to proceed?", preferredStyle: .alert)
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
    
    //MARK: - Ingredients and IngredientsList Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
        let ingredients = recipe?.ingredients?.count
        return ingredients ?? 0
        }
        if tableView == ingredientsListTableView {
            return ingredientsList.count
        }
        return 0
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
        }
        if tableView == ingredientsListTableView {
            let cell = ingredientsListTableView.dequeueReusableCell(withIdentifier: "ingredientsListCell", for: indexPath)
            let ingredient = ingredientsList[indexPath.row]
            cell.textLabel?.text = ingredient
            return cell
        }
        return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ingredientsListTableView {
            let ingredient = ingredientsList[indexPath.row]
            searchBar.text = ingredient
        }
    }
}


//MARK: - Picker view Functionality

extension AddRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    static let units = ["", "c", "pt", "tbsp", "tsp", "qt", "floz", "mL", "L", "lb", "g", "oz"]
//    static let units = [UnitVolume.cups, .pints, .tablespoons, .teaspoons, .quarts, .fluidOunces, .milliliters, .liters]
    
//    static let listOfUnits = [UnitMass.pounds, .grams, .ounces]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        var abrvs: [String] = []
//        for unit in AddRecipeViewController.units {
//            let abrv = unit.symbol
//            abrvs.append(abrv)
//        }
//        for un in AddRecipeViewController.listOfUnits {
//            let u = un.symbol
//            abrvs.append(u)
//        }
//        return abrvs[row]
        return AddRecipeViewController.units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AddRecipeViewController.units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let indexPath = unitPickerView.selectedRow(inComponent: component)
        let name = AddRecipeViewController.units[indexPath]
        view.endEditing(true)
        unitTextView.text = name
    }
    
}
