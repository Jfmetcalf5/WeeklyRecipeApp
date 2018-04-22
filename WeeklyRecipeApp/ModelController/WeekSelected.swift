//
//  WeekSelected.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/21/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation
import CoreData

class WeekSelectedController {
    
    static let shared = WeekSelectedController()
    
    var tempWeekSelected: WeekSelected?
    
    @discardableResult func fetchWeek() -> WeekSelected {
        
        let request: NSFetchRequest<WeekSelected> = WeekSelected.fetchRequest()
        
        do {
            let weekSelected = (try CoreDataStack.context.fetch(request))
            for week in weekSelected {
                tempWeekSelected = week
                return week
            }
        } catch let e {
            print("Error fetching WeekSelected from CoreData :\(e.localizedDescription)")
            return WeekSelected(week: "Saturday")
        }
        return WeekSelected(week: "Saturday")
    }
    
    func saveTheWeekSelected(week: String) {
        let _ = WeekSelected(week: week)
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
