//
//  RecipeController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation
import CoreData

class RecipeController {
    
    static let shared = RecipeController()
    
    var recipes: [Recipe] {
        
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
    
    func addRecipeWith(title: String, ingredients: [Ingredient], directions: String) {
        let _ = Recipe(title: title, ingredients: ingredients, directions: directions)
        saveToPersistentStore()
    }
    
    func delete(recipe: Recipe) {
        if let moc = recipe.managedObjectContext {
            moc.delete(recipe)
            saveToPersistentStore()
        }
    }
    
    func update(recipe: Recipe, with title: String, ingredients: [Ingredient], directions: String) {
        recipe.title = title
        //        recipe.ingredients = ingredients     NEED HELP WITH THIS TMORROW!!!
        //-------------------------------------------------------------------
        recipe.directions = directions
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
