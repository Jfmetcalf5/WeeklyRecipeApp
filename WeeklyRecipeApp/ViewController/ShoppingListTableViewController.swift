//
//  ShoppingListTableViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/24/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UITableViewController, ShoppingListTableViewControllerDelegate {
    
    var day: String?
    var days: [Day] = []
    var weeksIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.allowsSelection = false
        getAndCheck()
        checkIfTodaysTheDay()
        navigationItem.title = day ?? "Unknown Day?"
    }
    
    func checkBoxButtonTapped(sender: ShoppingListIngredientTableViewCell) {
        guard let day = day else { return }
        let today = ShoppingListController.shared.checkIfTodayIsTheDayToGoShopping(days: days, for: day)
        if Date().day == today?.date?.day {
            guard let indexPath = tableView.indexPath(for: sender) else { return }
            let selectedIngredient = weeksIngredients[indexPath.row]
            IngredientController.shared.updateIsChecked(ingredient: selectedIngredient)
            sender.updateCellViews()
        }
    }
    
    func getAndCheck() {
        let day = UserDefaults.standard.string(forKey: "DayWasSelected")
        let daysForVisibleMonth = ShoppingListController.shared.checkAndGetAllMatchingDaysForVisibleMonth()
        self.day = day
        self.days = daysForVisibleMonth
    }
    
    func checkIfTodaysTheDay() {
        if days != [] {
            guard let day = day else { return }
            if let today = ShoppingListController.shared.checkIfTodayIsTheDayToGoShopping(days: days, for: day) {
                
                let weeksWorthIngredients = ShoppingListController.shared.getTheIngredientsForTheNextSixDaysFrom(matchingDay: today)
                let sortedIngredients = weeksWorthIngredients.sorted(by: {$0.name ?? "" < $1.name ?? ""})
                
                var ingredientCountDictionary: [String: Int16] = [:]
                
                for ingredient in sortedIngredients {
                    
                    guard let ingredientName = ingredient.name,
                        let unit = ingredient.unit else { continue }
                    
                    if let numberOfIngredient = ingredientCountDictionary["\(ingredientName) \(unit)"] {
                        ingredientCountDictionary["\(ingredientName) \(unit)"] = numberOfIngredient + ingredient.quantity
                    } else {
                        ingredientCountDictionary["\(ingredientName) \(unit)"] = ingredient.quantity
                    }
                }
                
                var ingredients: [Ingredient] = []
                
                for (key, value) in ingredientCountDictionary {
                    let keys = key.components(separatedBy: " ")
                    guard let name = keys.first,
                        let unit = keys.last else { return }
                    let ingredient = Ingredient(name: name, quantity: value, unit: unit)
                    ingredients.append(ingredient)
                }
                
                self.weeksIngredients = ingredients
                tableView.reloadData()
                
                if Date().day == today.date?.day {
                    let alert = UIAlertController(title: "Today's The Day!", message: "You should have a formulated shopping list that you can take to the store!", preferredStyle: .alert)
                    let sweetAction = UIAlertAction(title: "Sweet", style: .default, handler: nil)
                    alert.addAction(sweetAction)
                    present(alert, animated: true, completion: nil)
                }
            }
            tableView.reloadData()
            let alert = UIAlertController(title: "Almost there!", message: "You cant do anything to the list yet. Come back on \(day) and you will be able to edit and check off your shopping list", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeksIngredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weeksIngredientCell", for: indexPath) as? ShoppingListIngredientTableViewCell else { return UITableViewCell() }
        
        guard let day = day else { return UITableViewCell() }
        let today = ShoppingListController.shared.checkIfTodayIsTheDayToGoShopping(days: days, for: day)
        if Date().day != today?.date?.day {
            cell.checkBoxButton.isHidden = true
            cell.delegate = self
            
            let ingredient = weeksIngredients[indexPath.row]
            cell.ingredient = ingredient
            
            return cell
        } else {
            cell.checkBoxButton.isHidden = false
            cell.delegate = self
            
            let ingredient = weeksIngredients[indexPath.row]
            cell.ingredient = ingredient
            
            return cell
        }
    }
    
//    var tempDeletedIngredient: [Ingredient] = []
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            let ingredient = weeksIngredients[indexPath.row]
//            tempDeletedIngredient.append(ingredient)
//            weeksIngredients.remove(at: indexPath.row)
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//
//    // MARK: - Navigation
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDeletedIngredients" {
//            guard let detailVC = segue.destination as? DeletedIngredientsTableViewController else { return }
//            detailVC.deletedIngredients = tempDeletedIngredient
//        }
//    }
}
