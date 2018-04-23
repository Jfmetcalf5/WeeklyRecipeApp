//
//  IngredientsList.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/23/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation

class IngredientsList {
    
    private let ingredientsKey = "ingredients"
    
    let ingredients: String
    
    init?(dictionary: [String: Any]) {
        guard let ingredients = dictionary[ingredientsKey] as? String else { return nil }
        
        self.ingredients = ingredients
    }
    
}
