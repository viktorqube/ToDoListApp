//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 06.10.2020.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    //MARK: - Outlets
    
    var addNewTask: String = ""
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addTaskTextField: UITextView!
    weak var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTaskTextField.delegate = self
        addTaskTextField.becomeFirstResponder()
        
        self.view.backgroundColor = UIColor.init(hex: 0x64a165)
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillShow(with:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
        )
        
        
        
    }
    @objc func keyboardWillShow(with notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - Actions
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let task = addTaskTextField.text, task.count > 0
        else {
            return
        }
        delegate?.didAddTask(task: task)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
extension AddTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden {
            addTaskTextField.text.removeAll()
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}


