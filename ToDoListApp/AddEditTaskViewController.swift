//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 07.10.2020.
//

import UIKit



class AddEditTaskViewController: UIViewController, UITextViewDelegate {
    
    enum ScreenType {
        case edit
        case create
    }
    
    //MARK: - Outlets
    
   
    var screenType:                      ScreenType!
    weak var delegateEdit:               ToDoListViewController?
    weak var delegateCreate:             ToDoListViewController?
    var taskToEddit:                     String = ""
    var editedTaskIndex:                 Int = 0
    @IBOutlet weak var taskLabel:        UILabel!
    @IBOutlet weak var taskToShow:       UITextView!
    @IBOutlet weak var doneButton:       UIButton!
    @IBOutlet weak var cancelButton:     UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(hex: 0x64a165)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(with:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        setupView()
        doneButton.backgroundColor   = UIColor.init(hex: 0xccfff8)
        doneButton.tintColor         = UIColor.init(hex: 0xd47c3f)
        cancelButton.backgroundColor = UIColor.init(hex: 0xccfff8)
        cancelButton.tintColor       = UIColor.init(hex: 0xd47c3f)
        taskToShow.delegate          = self
        taskToShow.becomeFirstResponder()
        taskToShow.textColor         = .white
        taskLabel.textColor          = .white
        self.view.backgroundColor    = UIColor.init(hex: 0xb5ebe5)
        
    }
    
    @objc func keyboardWillShow(with notification: NSNotification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight
        
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
        switch screenType {
        case .edit:
            delegateEdit?.didEditTask(task: taskToShow.text!, index: editedTaskIndex)
        case .create:
            delegateCreate?.didAddTask(task: task)
            taskToShow.text = "Say something..."
            taskLabel.text = "Waht's your plan for today?"
        case .none:
            print("error Found")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        switch screenType {
        case .edit:
            taskToShow.text = taskToEddit
            taskLabel.text = "Edit your task"
        case .create:
            taskToShow.text = "Say something..."
            taskLabel.text = "What's your next task?"
        case .none:
            print("error")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden {
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.taskToShow.text.removeAll()
            }
            switch screenType {
            case .edit:
                taskLabel.text = taskToEddit
            case .create:
                print("create mod")
            case .none:
                print("error")
            }
        }
    }
    
    
    
    
}

