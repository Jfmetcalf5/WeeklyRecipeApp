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
    
    @IBOutlet weak var changeDayButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var WeekDaySelected: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    let weeks = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var weekDay: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let week = WeekSelectedController.shared.fetchWeek()
        if UserDefaults.standard.bool(forKey: dayWasSelectedKey) == true {
            
            pickerView.isHidden = true
            changeDayButton.isHidden = true
            
            weekDay = week.week
            
            guard let day = weekDay else { return }
            print("User has previously selected \(day)")
            
            selectButton.setTitle("Continue", for: .normal)
            WeekDaySelected.text = weekDay
            descriptionLabel.text = "You have selected \(day) if you would like to change it click the top left button, otherwise press continue"

        } else {
            WeekDaySelected.isHidden = true
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    @IBAction func changeDayButtonTapped(_ sender: UIButton) {
        print("I need to present an alert here to make it all work out ⌨️")
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
        WeekSelectedController.shared.saveTheWeekSelected(week: weekDay)
        UserDefaults.standard.set(true, forKey: dayWasSelectedKey)
    }
}


