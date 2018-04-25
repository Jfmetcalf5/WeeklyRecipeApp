//
//  ShoppingListController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/24/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation

class ShoppingListController {
    
    static let shared = ShoppingListController()
    
    var dayOfWeek: String?
    
    var day: Day?
    
    func getTheSelectedDay() -> String {
        guard let weekSelected = WeekSelectedController.shared.tempWeekSelected,
            let dayOfWeek = weekSelected.dayOfWeek else { return "" }
        self.dayOfWeek = dayOfWeek
        return dayOfWeek
    }
    
    func checkAndGetAllDaysForVisibleMonth() -> [Day] {
        let days = DayController.shared.daysOfMonth
        var matchingDays: [Day] = []
        for day in days {
            if dayOfWeek == day.dayOfWeek {
                matchingDays.append(day)
            }
        }
        return matchingDays
    }
    
    func checkIfTodayIsTheDayToGoShopping(days: [Day]) -> Day? {
        let todaysDate = Calendar.current.component(.day, from: Date())
        for day in days {
            if todaysDate == day.date?.day {
                return day
            }
            continue
            
            // ALSO... IT CHECKS ON MONTH THAT IS VISIBLE... MAYBE I NEED TO BE LES SPECIFIC AND USE THE Day object RATHER THAN THE dayOfWeek............
        }
        return nil
    }
    
    func getTheIngredientsForTheNextSixDaysFrom(day: Day) {
        
        let sixDaysFromToday = Calendar.current.component(.day, from: Date(timeInterval: 604800, since: Date()))
            // NEED HELP HERE TOMORROW.... NOT SURE HOW TO ASSOCIATE THE DAY WITH THIS
        
        // BUT STILL WORK ON IT ON YOUR OWN!!! PLEASE!!!
    }

}
