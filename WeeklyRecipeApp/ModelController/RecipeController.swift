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
    
    @discardableResult func add(recipe: Recipe, to day: Day) -> Recipe {
        day.recipes = [recipe]
        recipe.days = [day]
        saveToPersistentStore()
        return recipe
    }
    
    func delete(recipe: Recipe) {
        if let moc = recipe.managedObjectContext {
            moc.delete(recipe)
            saveToPersistentStore()
        }
    }
    
    func update(recipe: Recipe, with title: String, directions: String) {
        recipe.title = title
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
