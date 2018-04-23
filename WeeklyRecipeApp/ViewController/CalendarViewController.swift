//
//  CalendarViewController.swift
//  WeeklyRecipeApp
//
//  Created by Jacob Metcalf on 4/18/18.
//  Copyright © 2018 JfMetcalf. All rights reserved.
//

import UIKit

protocol CalendarViewControllerDelegate: class {
    func recipeHasBeenDeletedOn(day: Day)
}

enum MyTheme {
    case light
    case dark
}

class CalendarViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, CalendarViewDelegate {
    
    @IBOutlet weak var dayRecipesTableView: UITableView!
    
    var theme = MyTheme.dark
    
    private var selectedDay: Day?
    
    weak var delegate: CalendarViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        calenderView.delegate = self
        
        setupCalendarView()
        self.title = "My Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        dayRecipesTableView.delegate = self
        dayRecipesTableView.dataSource = self
        dayRecipesTableView.alpha = 0
        
        calenderView.delegate = self
        
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
    
    @IBAction func changeDayButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Switch Day?", message: "Are you sure you would like to switch the days?  It will erase your current day!", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (yes) in
            self.performSegue(withIdentifier: "toChangeDay", sender: self)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { (no) in
            print("They'd rather not change days... 😬")
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func dayCellWasSelected(day: Day) {
        let day = day
        selectedDay = day
        dayRecipesTableView.reloadData()
    }
    
    //MARK: - RecipeTableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDay?.recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dayRecipesTableView.dequeueReusableCell(withIdentifier: "dayRecipeListCell", for: indexPath)
        
        let recipe = selectedDay?.recipes?.object(at: indexPath.row) as? Recipe
        
        cell.textLabel?.text = recipe?.title
        cell.detailTextLabel?.text = recipe?.directions
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let daysRecipes = selectedDay?.recipes?.array as? [Recipe],
                let day = selectedDay else { return }
            
            let recipeToDelete = daysRecipes[indexPath.row]
            
            RecipeController.shared.remove(recipe: recipeToDelete, from: day)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if day.recipes?.count == 0 {
            delegate?.recipeHasBeenDeletedOn(day: day)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    var calenderView: CalenderView!
    
    func setupCalendarView() {
        let v = CalenderView(theme: MyTheme.light, parentVC: self)
        v.translatesAutoresizingMaskIntoConstraints=false
        self.calenderView = v
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if calenderView.isSelected == true {
            if segue.identifier == "toCalendarRecipeList" {
                guard let detailVC = segue.destination as? DayRecipeViewController else { return }
                let selectedDay = self.selectedDay
                detailVC.day = selectedDay
            }
        } else if segue.identifier == "toChangeDay" {
                guard let detailVC = segue.destination as? WelcomeViewController else { return }
                detailVC.weekDay = ""
        } else {
            let alert = UIAlertController(title: "Missing", message: "Please select a date that you want to add a recipe too", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
