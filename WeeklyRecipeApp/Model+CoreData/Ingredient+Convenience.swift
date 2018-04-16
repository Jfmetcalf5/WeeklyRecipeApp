//
//  Ingredient+Convenience.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation
import CoreData

extension Ingredient {
    convenience init(name: String, context: NSManagedObjectContext = CoreDateStack.context) {
        self.init(context: context)
        self.name = name
    }
}
