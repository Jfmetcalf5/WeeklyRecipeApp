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
    
    func checkIfTodayIsTheDayToGoShopping(days: [Day]) -> Day? {
        let todaysDate = Calendar.current.component(.day, from: Date())
        let todaysMonth = Calendar.current.component(.month, from: Date())
        let todaysYear = Calendar.current.component(.year, from: Date())
        for day in days {
            if todaysDate == day.date?.day && todaysMonth == day.date?.month && todaysYear == day.date?.year {
                return day
            }
            continue
        }
        return nil
    }
    
    func getTheIngredientsForTheNextSixDaysFrom(matchingDay: Day) -> [Ingredient] {
        guard let fromDate = matchingDay.date,
            let toDate = matchingDay.date?.addingTimeInterval(604800) else { return [] }
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
