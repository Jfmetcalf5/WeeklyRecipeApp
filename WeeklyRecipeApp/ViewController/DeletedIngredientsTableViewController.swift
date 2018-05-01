//
//  DeletedIngredientsTableViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 5/1/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class DeletedIngredientsTableViewController: UITableViewController {
    
    var deletedIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deletedIngredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deletedIngredientCell", for: indexPath)
        
        let ingredient = deletedIngredients[indexPath.row]
        
        cell.textLabel?.text = "\(ingredient.quantity) \(ingredient.unit ?? "*")"
        cell.textLabel?.textColor = UIColor.black.withAlphaComponent(0.8)
        cell.detailTextLabel?.text = ingredient.name
        cell.detailTextLabel?.textColor = UIColor.black.withAlphaComponent(0.8)

        cell.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        return cell
    }
}
