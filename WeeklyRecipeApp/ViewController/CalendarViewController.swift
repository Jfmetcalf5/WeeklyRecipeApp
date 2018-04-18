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

class CalendarViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, CalendarViewDelegate {
    
    
    @IBOutlet weak var recipeTableView: UITableView!
    var theme = MyTheme.dark
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        
        self.title = "My Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.alpha = 0
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.recipeTableView.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        recipeTableView.alpha = 0
    }
    
    func calendarViewCellSelected(collectionView: UICollectionView, indexPath: IndexPath) {
        //        if let dayCell = calenderView.selectedCell {
        //            if recipe != nil {
        //                dayCell.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        //                calenderView.myCollectionView.reloadData()
        //            }
        //        }
    }
    
    //MARK: - RecipeTableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeController.shared.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeTableView.dequeueReusableCell(withIdentifier: "recipeListCell", for: indexPath)
        let recipe = RecipeController.shared.recipes[indexPath.row]
        
        cell.textLabel?.text = "\(String(describing: recipe.title))"
        cell.detailTextLabel?.text = "\(String(describing: recipe.directions))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if calenderView.isSelected == true {
            let alert = UIAlertController(title: "Confirm?", message: "Do you want to add a recipe to the \(calenderView.todaysDate)", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (yes) in
                
                let recipe = RecipeController.shared.recipes[indexPath.row]
//                self.performSegue(withIdentifier: "<#T##String#>", sender: indexPath)
                
                guard let dayCell = self.calenderView.selectedCell else { return }
                dayCell.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
            }
            
            let noAction = UIAlertAction(title: "No", style: .default) { (no) in
                return
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }
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
        let v=CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
