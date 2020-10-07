//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 07.10.2020.
//

import UIKit

class HomeViewController: UIViewController {

    var advice = ["Чтобы сделать задачу, нужно встать с дивана!",
                         "Задача сама себя не сделает!",
                         "Или ты задачу, или лень тебя!",
                         "Встань и делай!",
                         "Ты еще тут?",
                         "Хватит тыкать!",
                         "Move, Move, Move!",
                         "Тыкни плюсик, сделай задачу и радуйся!",
                         "Почему так много задач? Потому, что ты сидишь!",
                         "Лень хороша, когда ты спишь!",
                         "Поставил цель - иди, не можешь - ползи!",
                         "Все проблемы в твоей голове!",
    ]
    
    @IBOutlet weak var adviceTextLabel: UITextView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
       
    }
    
    @IBAction func adviceButtonPressed(_ sender: UIButton) {
        adviceTextLabel.text = advice.randomElement()
    }
    
    @IBAction func moveToToDoListButtonPressed(_ sender: UIButton) {
    }
    
}
