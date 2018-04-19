//
//  DayRecipeViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/18/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class DayRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendarRecipesTableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    var selectedDay: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        calendarRecipesTableView.delegate = self
        calendarRecipesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarRecipesTableView.reloadData()
    }
    
    func updateViews() {
        guard let selectedDay = selectedDay else { return }
        dateLabel.text = "\(selectedDay.day)"
    }
    
    //MARK: - RecipeTableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeController.shared.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calendarRecipesTableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let recipe = RecipeController.shared.recipes[indexPath.row]
        
        cell.textLabel?.text = recipe.title
        cell.detailTextLabel?.text = recipe.directions
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell")
        let selectedRecipe = RecipeController.shared.recipes[indexPath.row]
        recipeNameLabel.text = selectedRecipe.title
        cell?.isSelected = false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddRecipeToDay" {
            guard let indexPath = calendarRecipesTableView.indexPathForSelectedRow,
            let detailVC = segue.destination as? CalendarViewController,
            let date = selectedDay else { return }
            let recipe = RecipeController.shared.recipes[indexPath.row]
//            DayController.shared.add(recipe: recipe, to: date)
            detailVC.recipe = recipe
        }
    }

}
