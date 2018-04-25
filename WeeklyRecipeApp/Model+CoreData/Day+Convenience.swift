//
//  Day+Convenience.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/19/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation
import CoreData

extension Day {
    convenience init(date: Date, recipes: [Recipe], dayOfWeek: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.dayOfWeek = dayOfWeek
    }
}
