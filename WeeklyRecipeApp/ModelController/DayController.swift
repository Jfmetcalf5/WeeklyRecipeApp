//
//  DayController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/19/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation
import CoreData

class DayController {
    
    static let shared = DayController()
    
    private let daysHaveBeenCreatedKey = "DaysHaveBeenCreated"
    
    @discardableResult func add(recipe: Recipe, to day: Day) -> Recipe {
        day.addToRecipes(recipe)
        saveToPersistentStore()
        return recipe
    }
    
    func createDaysForTenYears() {
        guard UserDefaults.standard.bool(forKey: daysHaveBeenCreatedKey) == false else { return }
        var dates: [Date] = []
        
        for i in 0...3650 {
            guard let date = Calendar.current.date(byAdding: .day, value: i, to: Date()) else { continue }
            dates.append(date)
        }
        for date in dates {
            let _ = Day(date: date, recipes: [])
        }
        saveToPersistentStore()
        UserDefaults.standard.set(true, forKey: daysHaveBeenCreatedKey)
    }
    
    var daysOfMonth: [Day] = []
    
    func fetchDaysFor(month: Int, year: Int, lastDay: Int) {
        var firstDayOfMonth: Date?
        var lastDayOfMonth: Date?
        let firstComponents = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: year, month: month, day: 1, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let lastComponents = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: year, month: month, day: lastDay, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        firstDayOfMonth = Calendar.current.date(from: firstComponents)
        lastDayOfMonth = Calendar.current.date(from: lastComponents)
        guard let firstDay = firstDayOfMonth,
            let lastDay = lastDayOfMonth else { return }
        
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        
        let predicate1 = NSPredicate(format: "date >= %@", firstDay as NSDate)
        let predicate2 = NSPredicate(format: "date <= %@", lastDay as NSDate)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        request.predicate = compound
        do {
            let days = (try CoreDataStack.context.fetch(request))
            daysOfMonth = days
        } catch let e {
            print("Error fetching Days from CoreData :\(e.localizedDescription)")
        }
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
