//
//  CompletedTasksViewController.swift
//  ToDoListApp
//
//  Created by Viktor Qube on 07.12.2020.
//

import UIKit



class CompletedTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var CompletedTaskLabel: UILabel!
    @IBOutlet weak var completedTaskTableView: UITableView!
    
    var sortedCompletedTaskArra = [String]()
    var completedTasks = [String]()
    private let keyTask = "completedTasksKey"
    
   
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UISettings()
        CompletedTaskLabel.textColor  = UIColor.white
        loadNewTask()
        didAddCompletedTask()
       
        
    }
    
  
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteAllButtonPressed(_ sender: UIButton) {
        if completedTasks.count <= 0 {
            sender.shake()
        }
        completedTasks.removeAll()
        saveTasks()
        completedTaskTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCompId", for: indexPath)
        cell.textLabel?.text = completedTasks[indexPath.item]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Avenir Next Bold", size: 20)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        return cell
}
    func UISettings(){
//        deleteAllButton.backgroundColor = UIColor.init(hex: 0x66a6a1)
//        cancellButton.backgroundColor = UIColor.init(hex: 0x66a6a1)
        deleteAllButton.tintColor = .white
        cancellButton.tintColor = .white
        
        view.setGradientBackground(colorOne: UIColor.init(hex: 0x9cfff7),
                                   colorTwo: UIColor.init(hex: 0x000000))
        completedTaskTableView.backgroundColor = .clear
        completedTaskTableView.dataSource = self
        completedTaskTableView.delegate   = self
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        completedTasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        saveTasks()
    }
    
    func didAddCompletedTask() {
        for task in sortedCompletedTaskArra {
            completedTasks.insert(task, at: 0)
        }
        
//        completedTasks.append(contentsOf: sortedCompletedTaskArra)
        saveTasks()
        completedTaskTableView.reloadData()
        sortedCompletedTaskArra.removeAll()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.completedTasks.remove(at: indexPath.row)
            self.saveTasks()
            self.completedTaskTableView.reloadData()
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = UIColor.init(hex: 0x451c1e)
        return UISwipeActionsConfiguration(actions: [action])
    }
    func saveTasks() {
        UserDefaults.standard.set(completedTasks, forKey: keyTask)
    }
    
    func loadNewTask() {
        if let loadedTasks:[String] = UserDefaults.standard.value(forKey: keyTask) as? [String] {
            completedTasks = loadedTasks
            completedTaskTableView.reloadData()
        }
    }
    
}


