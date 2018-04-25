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
            for dayOfWeek in weekSelected {
                tempWeekSelected = dayOfWeek
                return dayOfWeek
            }
        } catch let e {
            print("Error fetching WeekSelected from CoreData :\(e.localizedDescription)")
            return WeekSelected(dayOfWeek: "Saturday")
        }
        return WeekSelected(dayOfWeek: "Saturday")
    }
    
    func saveTheWeekSelected(week: String) {
        let _ = WeekSelected(dayOfWeek: week)
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
