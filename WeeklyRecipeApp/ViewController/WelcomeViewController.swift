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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        presentAlert()
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        if let weekDay = weekDay {
            UserDefaults.standard.set(weekDay, forKey: dayWasSelectedKey)
            UserDefaults.standard.set(true, forKey: "dayTrueWasSelected")
        }
    }
    
    func presentAlert() {
//        if UserDefaults.standard.bool(forKey: "WelcomeAlertSent") == false {
//            let alert = UIAlertController(title: "Welcome to _______", message: "Just for your information, when assigning a recipe to a specific day, you are currently unable to add multiple of the same recipe to the same day... this bug will be fixed soon", preferredStyle: .alert)
//            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
//            alert.addAction(okayAction)
//            present(alert, animated: true, completion: nil)
//        }
//        UserDefaults.standard.set(true, forKey: "WelcomeAlertSent")
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


