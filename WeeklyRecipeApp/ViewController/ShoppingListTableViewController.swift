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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAndCheck()
        checkIfTodaysTheDay()
    }
    
    func getAndCheck() {
        WeekSelectedController.shared.fetchWeek()
        let day = ShoppingListController.shared.getTheSelectedDay()
        let days = ShoppingListController.shared.checkAndGetAllDaysForVisibleMonth()
        self.day = day
        self.days = days
    }
    
    func checkIfTodaysTheDay() {
        if days != [] {
            if let today = ShoppingListController.shared.checkIfTodayIsTheDayToGoShopping(days: days) {
                let alert = UIAlertController(title: "Today's The Day!", message: "You should have a formulated shopping list that you can take to the store!", preferredStyle: .alert)
                let sweetAction = UIAlertAction(title: "Sweet", style: .default, handler: nil)
                alert.addAction(sweetAction)
                present(alert, animated: true, completion: nil)
                ShoppingListController.shared.getTheIngredientsForTheNextSixDaysFrom(matchingDay: today)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
