//
//  Recipe+Convenience.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation
import CoreData

extension Recipe {
    convenience init(title: String, ingredients: [Ingredient], directions: String, context: NSManagedObjectContext = CoreDateStack.context) {
        self.init(context: context)
        self.title = title
        self.directions = directions
    }
}
