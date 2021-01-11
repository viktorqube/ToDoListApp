//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 07.10.2020.
//

import UIKit

protocol CompletedTaskDelegate {
    func didCompletTask(completedTask: String)
}

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    private let keyTask = "keyTask"
    var tasks = [String]()
    var completedTasksToAdd = [String]()
    var orderedCompletedTasksArray = [String]()
    var completedTaskDelegate: CompletedTaskDelegate!
    var indexForCompletedTasks = Int()
    
    
    @IBOutlet weak var button: UIButton!
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var addTascVC: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak private var toDoLabel:     UILabel!
    
    @IBOutlet weak var completedTasVC: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
        
        
        tableViewUISettings()
        toDoLabel.textColor = UIColor.white
        loadNewTask()
        addTascVC.backgroundColor = .clear
        completedTasVC.backgroundColor = .clear
    }
    
    @IBAction func addNewTaskButtonTapped(_ sender: UIButton) {
        sender.pulsate()
        let vc = AddEditTaskViewController()
        vc.delegateCreate = self
        vc.screenType = .create
        present(vc, animated: true, completion: nil)
    }
   
    
   
    @IBAction func completedTaskButtonPressed(_ sender: UIButton) {
        sender.pulsate()
        let vc = storyboard?.instantiateViewController(withIdentifier: "completedTasksListVC") as! CompletedTasksViewController
        for element in orderedCompletedTasksArray {
            if tasks.contains(element) {
                print("sameeeeeeeeeeee")
            } else {
                vc.sortedCompletedTaskArra.append(element)
            }
            orderedCompletedTasksArray.removeAll()
        }
        completedTasksToAdd.removeAll()
        present(vc, animated: true, completion: nil)
    }
    
  
    
    
    //MARK: - TableView settings
    func tableViewUISettings(){
        view.setGradientBackground(colorOne: UIColor.init(hex: 0x9cfff7),
                                   colorTwo: UIColor.init(hex: 0x000000))
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate   = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.item]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Avenir Next Bold", size: 20)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object       = tasks[indexPath.row]
        let index          = indexPath.row
        let vc             = AddEditTaskViewController()
        vc.delegateEdit    = self
        vc.editedTaskIndex = index
        vc.taskToEddit     = object
        vc.screenType      = .edit
        present(vc, animated: true, completion: nil)
    }
    
    func didEditTask(task: String, index: Int) {
        tasks.remove(at: index)
        tasks.insert(task, at: index)
        tableView.reloadData()
        saveTasks()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        saveTasks()
    }
    
    // MARK: - Actions
   
    

        func didAddTask(task: String) {
        tasks.insert(task, at: 0)
        saveTasks()
        tableView.reloadData()
    }
    
    //MARK: - Save/Load tasks in UserDefaults
    func saveTasks() {
        UserDefaults.standard.set(tasks, forKey: keyTask)
    }
    
    func loadNewTask() {
        if let loadedTasks:[String] = UserDefaults.standard.value(forKey: keyTask) as? [String] {
            tasks = loadedTasks
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
           
            self.tasks.remove(at: indexPath.row)
            self.saveTasks()
            tableView.reloadData()
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = UIColor.init(hex: 0x451c1e)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            self.tasks.remove(at: indexPath.row)
            self.saveTasks()
            tableView.reloadData()
            completion(true)
        }
        completedTasksToAdd.append(tasks[indexPath.row])
        
        indexForCompletedTasks = indexPath.row
        print(completedTasksToAdd)
        orderedCompletedTasksArray = orderedSet(array: completedTasksToAdd)
        print(orderedCompletedTasksArray)
        action.image = #imageLiteral(resourceName: "done")
        action.backgroundColor = UIColor.init(hex: 0x1b401e)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func orderedSet<T: Hashable>(array: Array<T>) -> Array<T> {
        var unique = Set<T>()
        return array.filter { element in
            return unique.insert(element).inserted
        }
    }
    
    
    
    
    
}




