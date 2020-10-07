//
//  EditTaskViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 06.10.2020.
//

import UIKit

class EditTaskViewController: UIViewController {
    
    //MARK: - Outlets
    
    weak var delegate: ViewController?
    var taskToEddit: String = ""
    var editedTaskIndex: Int = 0
    
    @IBOutlet weak var taskToShow: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hex: 0x64a165)
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillShow(with:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
        )
        
        taskToShow.delegate = self
        taskToShow.becomeFirstResponder()
        
        setupView()
    }
    
    @objc func keyboardWillShow(with notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let task = taskToShow.text, task.count > 0
        else {
            return
        }
        
        delegate?.didEditTask(task: taskToShow.text!, index: editedTaskIndex)
        print(editedTaskIndex)
        print(taskToShow.text!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        taskToShow.text = taskToEddit
    }
}

extension EditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden {
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
