//
//  ShoppingListTableViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/24/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {
    
    var day: String?
    var days: [Day] = []
    var weeksIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAndCheck()
        checkIfTodaysTheDay()
        navigationItem.title = day ?? "Unknown Day?"

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
                self.weeksIngredients = weeksWorthIngredients
                tableView.reloadData()
                
                if Date() == day.date {
                    let alert = UIAlertController(title: "Today's The Day!", message: "You should have a formulated shopping list that you can take to the store!", preferredStyle: .alert)
                    let sweetAction = UIAlertAction(title: "Sweet", style: .default, handler: nil)
                    alert.addAction(sweetAction)
                    present(alert, animated: true, completion: nil)
                }
            }
            let alert = UIAlertController(title: "Almost there!", message: "You cant do anything to the list yet. Come back on \(day) and you will be able to edit and check off your shopping list", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeksIngredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weeksIngredientCell", for: indexPath)
        
        let ingredient = weeksIngredients[indexPath.row]
        
        cell.textLabel?.text = "\(ingredient.quantity) \(ingredient.unit ?? "")"
        cell.detailTextLabel?.text = ingredient.name

        
        return cell
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
