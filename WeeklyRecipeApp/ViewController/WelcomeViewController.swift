//
//  WelcomeViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/16/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var selectDayButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    
    
    let weeks = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var week: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton.isHidden = true
        pickerView.isHidden = true
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
        // I NEED TO SAVE THE DAY OF THE WEEK THAT THE USER TAPPED...
        //-----------------------------------------------------------
    }
    
    @IBAction func selectDateButtonTapped(_ sender: UIButton) {
        if pickerView.isHidden == true {
            selectDayButton.isHidden = true
            pickerView.isHidden = false
            selectButton.isHidden = false
        } else {
            selectDayButton.isHidden = false
            pickerView.isHidden = true
            selectButton.isHidden = false
        }
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        // I NEED TO SAVE THE DAY OF THE WEEK THAT THE USER TAPPED...
        //-----------------------------------------------------------
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // DO I NEED TO HAVE A DEGUE HERE??
        //-----------------------------------------------------------
    }

}
