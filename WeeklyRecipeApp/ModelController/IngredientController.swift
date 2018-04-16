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
    
    func addIngredientWith(name: String) {
        let ingredient = Ingredient(name: name)
        self.ingredients.append(ingredient)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDateStack.context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
