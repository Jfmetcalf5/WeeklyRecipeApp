//
//  RecipeController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation

class RecipeController {
    
    static let shared = RecipeController()
    
    var recipes: [Recipe] = []
    
    func addRecipeWith(title: String, ingredients: [Ingredient], directions: String) {
        let recipe = Recipe(title: title, ingredients: ingredients, directions: directions)
        self.recipes.append(recipe)
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
