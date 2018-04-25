//
//  ChangeDayViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/23/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class ChangeDayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let weeks = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var weekDay: String?
    
    @IBOutlet weak var changePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePickerView.delegate = self
        changePickerView.dataSource = self
    }
    
    @IBAction func changeDayButtonTapped(_ sender: UIButton) {
        guard let dayOfWeek = weekDay,
        let weekSelected = WeekSelectedController.shared.fetchWeek() else { return }
        WeekSelectedController.shared.update(weekSelected: weekSelected, with: dayOfWeek)
        UserDefaults.standard.set(true, forKey: "DayWasSelected")
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        WeekSelectedController.shared.saveTheWeekSelected(dayOfWeek: weeks[row])
        let dayOfWeek = weeks[row]
        self.weekDay = dayOfWeek
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
