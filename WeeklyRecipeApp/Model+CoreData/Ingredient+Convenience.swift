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
    convenience init(name: String, quantity: Int16, unit: String, isChecked: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.isChecked = isChecked
    }
}
