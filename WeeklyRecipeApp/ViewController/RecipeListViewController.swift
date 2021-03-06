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
        presentAlert()
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeTableView.reloadData()
    }
    
    func presentAlert() {
        if UserDefaults.standard.bool(forKey: "WelcomeAlertSent") == false {
            let alert = UIAlertController(title: "Welcome to Recipe Planner", message: "For your information, when assigning a recipe to a specific day, you are currently unable to add the same recipe multiple times to one day.  This bug will be fixed soon", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
        UserDefaults.standard.set(true, forKey: "WelcomeAlertSent")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return RecipeController.shared.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.outsidePlate
        } else {
            cell.backgroundColor = UIColor.outsidePlate.withAlphaComponent(0.5)
        }
        
        let recipe = RecipeController.shared.recipes[indexPath.row]
        cell.textLabel?.text = recipe.title
        cell.detailTextLabel?.text = recipe.directions
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = RecipeController.shared.recipes[indexPath.row]
            
            RecipeController.shared.delete(recipe: recipe)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetail" {
            guard let indexPath = recipeTableView.indexPathForSelectedRow,
            let detailVC = segue.destination as? RecipeInfoViewController else { return }
            let recipe = RecipeController.shared.recipes[indexPath.row]
            detailVC.recipe = recipe
        }
        else if segue.identifier == "toNewRecipe" {
            guard let detailVC = segue.destination as? AddRecipeViewController else { return }
            let recipe = Recipe(title: "", days: [], ingredients: [], directions: "")
            detailVC.recipe = recipe
        }
    }
}


//MARK: - NSFetchedResulstsControllerDelegate Methods
extension RecipeListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        recipeTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        recipeTableView.endUpdates()
    }
    
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

