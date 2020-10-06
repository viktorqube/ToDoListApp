//
//  EditTaskViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 06.10.2020.
//

import UIKit

class EditTaskViewController: UIViewController {
    
    weak var delegate: ViewController?
    var taskToEddit: String = ""
    var editedTaskIndex: Int = 0
    @IBOutlet weak var taskToShow: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    
    @IBAction func doneEdditing(_ sender: UIButton) {
        guard let task = taskToShow.text, task.count > 0
        else {
            return
        }
        
        delegate?.didEditTask(task: taskToShow.text!, index: editedTaskIndex)
        print(editedTaskIndex)
        print(taskToShow.text!)
        dismiss(animated: true, completion: nil)
    }
    func setupView() {
        taskToShow.text = taskToEddit
    }
    
}
