//
//  RecipeListViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit
import CoreData

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return RecipeController.shared.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        let recipe = RecipeController.shared.recipes[indexPath.row]
        cell.textLabel?.text = recipe.title
        cell.detailTextLabel?.text = recipe.directions
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = RecipeController.shared.recipes[indexPath.row]
            
            RecipeController.shared.delete(recipe: recipe)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetail" {
            guard let indexPath = recipeTableView.indexPathForSelectedRow,
            let detailVC = segue.destination as? RecipeInfoViewController else { return }
            let recipe = RecipeController.shared.recipes[indexPath.row]
            detailVC.recipe = recipe
        } else if segue.identifier == "toNewRecipe" {
            guard let detailVC = segue.destination as? AddRecipeViewController else { return }
            let recipe = Recipe(title: "", ingredients: [], directions: "")
            detailVC.recipe = recipe
        }
    }
}


//MARK: - NSFetchedResulstsControllerDelegate Methods
extension RecipeListViewController: NSFetchedResultsControllerDelegate {
    // Tell the table view I'm about to do a bunch of stuff
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        recipeTableView.beginUpdates()
    }
    // Tell the table view I finished doing my stuff, you do you thing
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        recipeTableView.endUpdates()
    }
    // I just created, read, updated, or seleted something
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            recipeTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            recipeTableView.deleteRows(at: [indexPath], with: .automatic)
        case.update:
            guard let indexPath = indexPath else { return }
            recipeTableView.reloadRows(at: [indexPath], with: .automatic)
        case.move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            recipeTableView.moveRow(at: indexPath, to: newIndexPath)
        }
    }
}

