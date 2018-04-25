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
    
    var day: Day?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarRecipesTableView.delegate = self
        calendarRecipesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarRecipesTableView.reloadData()
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
        if recipeNameLabel.text == "(Recipe Name)" {
            let alert = UIAlertController(title: "Recipe Needed", message: "Please select a recipe from the list before you precc 'Add Recipe'", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okayAction)
            return
        }
        if segue.identifier == "toAddRecipeToDay" {
            guard let indexPath = calendarRecipesTableView.indexPathForSelectedRow,
            let day = day else { return }
                let recipe = RecipeController.shared.recipes[indexPath.row]
            RecipeController.shared.add(recipe: recipe, to: day)
        }
    }
    
}
