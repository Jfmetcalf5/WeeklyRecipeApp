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
        //        mergeTheDuplicates()
    }
    
    //    func mergeTheDuplicates() {
    //        var startIndex = 0
    //        for ingredient in weeksIngredients {
    //            while startIndex < weeksIngredients.count - 1 {
    //                if ingredient == weeksIngredients[startIndex + 1] {
    //                    sameIngredients.append(ingredient)
    //                    sameIngredients.append(weeksIngredients[startIndex + 1])
    //                } else {
    //                    differentIngredients.append(ingredient)
    //                }
    //                startIndex += 1
    //            }
    //        }
    //    }
    //
    //    func addIngredientsThatAreTheSame() {
    //        var startIndex = 0
    //        var totalIngredients: Int?
    //        if sameIngredients.count > 1 {
    //            for ingredient in sameIngredients {
    //                while startIndex < sameIngredients.count - 1 {
    //                    let ingredient = sameIngredients.reduce(Ingredient, {$0 = $1)
    //                        //                        var mutIngredient = ingredient
    //                        //                        let totalIngredient = mutIngredient.quantity + sameIngredients[startIndex + 1].quantity
    //                        //                        startIndex += 1
    //                        //                        mutIngredient.quantity = totalIngredient
    //                        //                            totalIngredients = Int(totalIngredient)
    //                    }
    //                }
    //                print("\(totalIngredients)")
    //            }
    //        }
    
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
        
        //        if todays date is the days date then add the image
        //        cell.imageView?.image = #imageLiteral(resourceName: "EmptyBox")
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //
    //            weeksIngredients.remove(at: indexPath.row)
    //
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
    //        }
    //    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
