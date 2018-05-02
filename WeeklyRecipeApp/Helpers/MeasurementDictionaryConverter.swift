//
//  MeasurementDictionaryConverter.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 5/1/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import Foundation

class MeasurementDictionaryConverter {
    
    static let shared = MeasurementDictionaryConverter()
    
    var measurementsDictionary: [String: String] = ["1 c": "8 oz", "1 pt": "2 c", " 1 tbsp": "3 tsp", "1 qt": "4 c", "1 floz": "2 tsp", "1 L": "33 floz", "1 lb": "16 oz", "1 gal": "4 qt", "1 gram": "0.3 oz", "1 oz": "28 gram"]
    
    var fractionsDictionary: [String:  Double] = ["1/8": 0.125, "1/4": 0.25, "1/2": 0.5, "3/4": 0.75, "1/3": 0.34,"2/3": 0.67]
}
