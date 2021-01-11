//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 07.10.2020.
//

enum ScreenType {
    case edit
    case create
}

import UIKit

class AddEditTaskViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    var screenType:                      ScreenType!
    weak var delegateEdit:               ToDoListViewController?
    weak var delegateCreate:             ToDoListViewController?
    var taskToEddit:                     String = ""
    var editedTaskIndex:                 Int = 0
    
    //MARK: - Outlets
    @IBOutlet weak var taskLabel:        UILabel!
    @IBOutlet weak var taskToShow:       UITextView!
    @IBOutlet weak var doneButton:       UIButton!
    @IBOutlet weak var cancelButton:     UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(with:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        
        setupView()
        UIElementsSetup()
        
        
    }
    
    func UIElementsSetup() {
        view.setGradientBackground(colorOne: UIColor.init(hex: 0x9cfff7),
                                   colorTwo: UIColor.init(hex: 0x000000))
        doneButton.backgroundColor = UIColor.init(hex: 0x5d9893)
        doneButton.tintColor = .white
        cancelButton.backgroundColor = UIColor.init(hex: 0x5d9893)
        cancelButton.tintColor = .white
        taskToShow.textColor = UIColor.white
        taskLabel.textColor = UIColor.white
        taskToShow.delegate = self
        taskToShow.becomeFirstResponder()
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
        sender.shake()
        
        guard let task = taskToShow.text, task.count > 0, task != " ", task != "  ", task != "   "
        else {return}
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
            UIView.animate(withDuration: 0.5){
                self.doneButton.isHidden = false
            }
            view.layoutIfNeeded()
            switch screenType {
            case .edit:
                taskToShow.text = taskToEddit
            case .create:
                UIView.animate(withDuration: 0.3){
                    self.taskToShow.text.removeAll()
                }
            case .none:
                print("error")
            }
        }
    }
    
    
    
    
    
    
    
}

