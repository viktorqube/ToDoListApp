//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 06.10.2020.
//

import UIKit

class AddTaskViewController: UIViewController {

    var addNewTask: String = ""
    
    @IBOutlet weak var addTaskTextField: UITextView!
    
    weak var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    
    @IBAction func addNewTaskPressed(_ sender: UIButton) {
        guard let task = addTaskTextField.text, task.count > 0
        else {
            return
        }
        delegate?.didAddTask(task: task)
        
        dismiss(animated: true, completion: nil)
    }
    
}
