//
//  WeekSelected+Convenience.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/21/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation
import CoreData

extension WeekSelected {
    convenience init(dayOfWeek: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.dayOfWeek = dayOfWeek
    }
}
