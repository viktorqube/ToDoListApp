//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 06.10.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    let keyTask = "keyTask"
    var tasks:[String] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        loadNewTask()
        
    }
    //MARK: - TableView settings
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.item]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = tasks[indexPath.row]
        let index = indexPath.row
        let vc = EditTaskViewController()
        vc.editedTaskIndex = index
        vc.taskToEddit = object
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
    
    @IBAction func addNewTaskButtonPressed(_ sender: UIButton) {
        let object = ""
        let vc = AddTaskViewController()
        vc.addNewTask = object
        vc.delegate = self
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
    
    
    
    
}
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "\(tasks.count) total tasks for the day"
    }
}

