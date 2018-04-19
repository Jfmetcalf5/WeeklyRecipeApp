//
//  CalendarViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/18/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
    case dark
}

class CalendarViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource/*, CalendarViewDelegate*/ {
    
    @IBOutlet weak var dayRecipesTableView: UITableView!
    
    var theme = MyTheme.dark
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        calenderView.delegate = self
        
        self.title = "My Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        dayRecipesTableView.delegate = self
        dayRecipesTableView.dataSource = self
        dayRecipesTableView.alpha = 0
        dayRecipesTableView.allowsSelection = false
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dayRecipesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.dayRecipesTableView.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dayRecipesTableView.alpha = 0
    }
    
    //MARK: - RecipeTableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard recipe != nil else { return 0 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dayRecipesTableView.dequeueReusableCell(withIdentifier: "dayRecipeListCell", for: indexPath)
        
        guard let recipe = recipe else { return UITableViewCell() }
        
        cell.textLabel?.text = recipe.title
        cell.detailTextLabel?.text = recipe.directions
        
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }
    
    let calenderView: CalenderView = {
        let v=CalenderView(theme: MyTheme.light)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if calenderView.isSelected == true {
            if segue.identifier == "toCalendarRecipeList" {
                guard let detailVC = segue.destination as? DayRecipeViewController else { return }
                let selectedDay = calenderView.selectedDate
                detailVC.selectedDay = selectedDay
            }
        } else {
            let alert = UIAlertController(title: "Missing", message: "Please select a date that you want to add a recipe too", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
