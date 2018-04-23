//
//  IngredientsListController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/23/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation

class IngredientsListController {
    
    static let shared = IngredientsListController()
    
    var allIngredients: [String] = []
    
    @discardableResult func fetchIngredients() -> [String] {
        
        guard let ingredientsJsonURL = Bundle.main.url(forResource: "Ingredients", withExtension: "json") else {
            fatalError("file was moved \(#file)")
        }
        
        guard let data = try? Data(contentsOf: ingredientsJsonURL),
            
        let ingredientsDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            print("There was an error doing th JSONSerialization")
            return [] }
        
        guard let ingredientsList = IngredientsList(dictionary: ingredientsDictionary) else {
            print("Unable to parse through the json that I got back")
            return [] }
        
        let allIngredients = ingredientsList.ingredients.components(separatedBy: ", ")
        
        self.allIngredients = allIngredients
        return allIngredients
    }
    
}
