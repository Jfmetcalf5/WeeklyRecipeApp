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
    
    let weeks = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    func createDaysForTenYears() {
        guard UserDefaults.standard.bool(forKey: daysHaveBeenCreatedKey) == false else { return }
        var dates: [Date] = []
        
        let firstComponents = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: 2018, month: 4, day: 1, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)

        guard let firstDayOfMonth = Calendar.current.date(from: firstComponents) else { return }

        for i in 0...3650 {
            guard let date = Calendar.current.date(byAdding: .day, value: i, to: firstDayOfMonth) else { continue }
            dates.append(date)
        }
        
        var dayOfWeek: String = "Sunday"
        
        for date in dates {
            let _ = Day(date: date, recipes: [], dayOfWeek: dayOfWeek)
            
            guard let nextDayOfWeek = nextDay(currentDay: dayOfWeek) else { return }
            
            dayOfWeek = nextDayOfWeek
        }
        saveToPersistentStore()
        UserDefaults.standard.set(true, forKey: daysHaveBeenCreatedKey)
    }
    
    func nextDay(currentDay: String) -> String? {
        guard let indexOfCurrentDay = weeks.index(of: currentDay) else { return nil }
        if indexOfCurrentDay < weeks.count - 1 {
            return weeks[indexOfCurrentDay + 1]
        } else {
            return weeks[0]
        }
    }
    
    func fetchRecipesFrom(day: Day) -> [Recipe] {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let predicate = NSPredicate(format: "%@ in days", day)
        request.predicate = predicate
        do {
            let recipes = (try CoreDataStack.context.fetch(request))
            return recipes
        } catch let e {
            print("Error fetching Days from CoreData :\(e.localizedDescription)")
            return []
        }
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
        let sortDesciptor = NSSortDescriptor(key: "date", ascending: true)
        request.predicate = compound
        request.sortDescriptors = [sortDesciptor]
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
