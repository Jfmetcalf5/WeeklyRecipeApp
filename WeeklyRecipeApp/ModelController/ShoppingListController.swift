//
//  ShoppingListController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/24/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation
import CoreData

class ShoppingListController {
    
    static let shared = ShoppingListController()
    
    var dayOfWeek: String?
    var daysInWeek: [Day] = []
    
    func getTheSelectedDay() {
        let dayOfWeek = UserDefaults.standard.string(forKey: "DayWasSelected")
        self.dayOfWeek = dayOfWeek
    }
    
    func checkAndGetAllMatchingDaysForVisibleMonth() -> [Day] {
        getTheSelectedDay()
        let days = DayController.shared.daysOfMonth
        var matchingDays: [Day] = []
        for day in days {
            if dayOfWeek == day.dayOfWeek {
                matchingDays.append(day)
            }
        }
        return matchingDays
    }
    
    func checkIfTodayIsTheDayToGoShopping(days: [Day], for dayOfWeek: String) -> Day? {
        let todaysDate = Calendar.current.component(.day, from: Date())
        let todaysMonth = Calendar.current.component(.month, from: Date())
        let todaysYear = Calendar.current.component(.year, from: Date())
        
        for day in days {
            guard let dayDay = day.date?.day, let monthDay = day.date?.month, let yearDay = day.date?.year, let dateDay = day.date else { return nil }
            if todaysDate == dayDay && todaysMonth == monthDay && todaysYear == yearDay {
                return day
            } else {
                if todaysDate <= dayDay && todaysMonth <= monthDay && todaysYear <= yearDay && dateDay.addingTimeInterval(-691200) < Date() {
                    return day
                }
            }
            continue
        }
        return nil
    }
    
    func getTheIngredientsForTheNextSixDaysFrom(matchingDay: Day) -> [Ingredient] {
        guard let fromDate = matchingDay.date?.addingTimeInterval(86400),
            let toDate = matchingDay.date?.addingTimeInterval(777600) else { return [] }
        let days = DayController.shared.fetchDaysInWeek(fromDate: fromDate, toDate: toDate)
        self.daysInWeek = days
        var ingredientsInWeek: [Ingredient] = []
        for day in days {
            guard let recipes = day.recipes?.array as? [Recipe] else { continue }
            if recipes.count > 1 {
                for recipe in recipes {
                    guard let ingredients = recipe.ingredients?.array as? [Ingredient] else { continue }
                    ingredientsInWeek.append(contentsOf: ingredients)
                }
            } else {
                guard let ingredients = recipes.first?.ingredients?.array as? [Ingredient] else { continue }
                ingredientsInWeek.append(contentsOf: ingredients)
            }
        }
        return ingredientsInWeek
    }
    
}
