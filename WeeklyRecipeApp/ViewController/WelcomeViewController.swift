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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let weeks = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var weekDay: String?
//    var weekSelected: WeekSelected?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let weekSelected = WeekSelectedController.shared.fetchWeek()
        self.weekDay = weekSelected?.dayOfWeek
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        if let weekDay = weekDay {
            WeekSelectedController.shared.saveTheWeekSelected(dayOfWeek: weekDay)
            UserDefaults.standard.set(true, forKey: dayWasSelectedKey)
        }
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
    }
}


