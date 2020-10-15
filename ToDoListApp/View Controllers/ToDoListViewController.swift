//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 07.10.2020.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDataSource {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var tableViewCell: UITableView!
    @IBOutlet weak private var tableView:     UITableView!
    @IBOutlet weak private var toDoLabel:     UILabel!
    
    private let keyTask        = "keyTask"
    private var tasks:[String] = []
    private var lastTask = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        toDoLabel.textColor  = UIColor.init(hex: 0xb5ebe5)
        loadNewTask()
        
    }
    
    //MARK: - TableView settings
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object         = tasks[indexPath.row]
        let index          = indexPath.row
        let vc = AddEditTaskViewController()
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
    
    @IBAction private func addNewTaskTaped(_ sender: UITapGestureRecognizer) {
        let vc            = AddEditTaskViewController()
        vc.delegateCreate = self
        vc.screenType     = .create
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
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = view as? UITableViewHeaderFooterView {
            footer.textLabel?.textColor = UIColor.init(hex: 0xd47c3f)
            footer.backgroundView?.backgroundColor = .white
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
        action.backgroundColor = UIColor.init(hex: 0xb5ebe5)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            self.tasks.remove(at: indexPath.row)
            self.saveTasks()
            tableView.reloadData()
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "done")
        action.backgroundColor = UIColor.init(hex: 0xb5ebe5)
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "                           \(tasks.count) To Do's to finish"
        
    }
}


