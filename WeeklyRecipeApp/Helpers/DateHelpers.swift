//
//  DateHelpers.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/19/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else { return Date() }
        return date
    }
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
