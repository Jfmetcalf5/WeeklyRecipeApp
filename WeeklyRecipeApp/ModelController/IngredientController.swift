//
//  IngredientController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation

class IngredientController {
    
    static let shared = IngredientController()
    
    func addIngredientWith(name: String, quantity: Double, unit: String, recipe: Recipe) {
        let ingredient = Ingredient(name: name, quantity: quantity, unit: unit)
        recipe.addToIngredients(ingredient)
        saveToPersistentStore()
    }
    
    func delete(ingredient: Ingredient) {
        if let moc = ingredient.managedObjectContext {
            moc.delete(ingredient)
            saveToPersistentStore()
        }
    }
    
    func updateIsChecked(ingredient: Ingredient) {
        ingredient.isChecked = !ingredient.isChecked
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
