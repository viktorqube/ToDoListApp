//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 07.10.2020.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    private let keyTask = "keyTask"
    var tasks:[String] = []
    var checkedTasks = ""
    
    //MARK: - Outlets
    @IBOutlet weak private var tableViewCell: UITableView!
    @IBOutlet weak private var tableView:     UITableView!
    @IBOutlet weak private var toDoLabel:     UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewUISettings()
        toDoLabel.textColor  = UIColor.white
        loadNewTask()
        
    }
    
    //MARK: - TableView settings
    func tableViewUISettings(){
        view.setGradientBackground(
            colorOne: UIColor.init(hex: 0x9cfff7),
            colorTwo: UIColor.init(hex: 0xf69272))
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.item]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
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
    @IBAction func deletedTasksListPressed(_ sender: UIButton) {
//        let vc = DeletedTasksViewController()
//        present(vc, animated: true, completion: nil)
        
    }
    @IBAction func addMewTaskTapped(_ sender: UITapGestureRecognizer) {
        let vc = AddEditTaskViewController()
        vc.delegateCreate = self
        vc.screenType = .create
        present(vc, animated: true, completion: nil)
        
    }
    
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
        action.backgroundColor = UIColor.init(hex: 0xffd1d1)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            self.tasks.remove(at: indexPath.row)
            self.saveTasks()
            tableView.reloadData()
            completion(true)
            
        }
        checkedTasks = tasks[indexPath.row]
        action.image = #imageLiteral(resourceName: "done")
        action.backgroundColor = UIColor.init(hex: 0xccffce)
        print(checkedTasks)
        return UISwipeActionsConfiguration(actions: [action])
    }
}




