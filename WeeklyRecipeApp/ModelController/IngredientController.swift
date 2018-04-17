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
    
    var ingredients: [Ingredient] = []
    
    func addIngredientWith(name: String, quantity: Int16) {
        let ingredient = Ingredient(name: name, quantity: quantity)
        self.ingredients.append(ingredient)
        saveToPersistentStore()
    }
    
    func delete(ingredient: Ingredient) {
        if let moc = ingredient.managedObjectContext {
            moc.delete(ingredient)
            saveToPersistentStore()
        }
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
