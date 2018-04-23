//
//  IngredientsListTableViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/23/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class IngredientsListTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var ingredientsList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ingredientsList = IngredientsListController.shared.fetchIngredients()
        self.ingredientsList = ingredientsList
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsListCell", for: indexPath)
        
        let ingredient = ingredientsList[indexPath.row]
        
        cell.textLabel?.text = ingredient
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddIngredientToAddIngredient" {
//            guard let detailVC = segue.destination as? AddRecipeViewController,
//            let indexPath = tableView.indexPathForSelectedRow else { return }
//            let selectedIngredient = ingredientsList[indexPath.row]
        }
    }
}
