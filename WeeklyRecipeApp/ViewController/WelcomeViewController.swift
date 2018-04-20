//
//  WelcomeViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let dayWasSelectedKey = "DayWasSelected"
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    
    
    let weeks = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var weekDay: String?
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    ////        guard UserDefaults.standard.bool(forKey: dayWasSelectedKey) == false else {
    //            print("Find some way to present the next view controller")
    //            //            guard let recipeController = UIViewController() as? RecipeListViewController else { return }
    //            //                        present(recipeController, animated: true, completion: nil)
    //            //            return }
    //        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    //MARK: - UIPickerViewSetup
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weeks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weeks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let weekDay = weeks[row]
        self.weekDay = weekDay
        saveSelectedDay()
    }
    
    func saveSelectedDay() {
        guard let _ = weekDay else { return }
        UserDefaults.standard.setValue(true, forKey: dayWasSelectedKey)
    }
}


