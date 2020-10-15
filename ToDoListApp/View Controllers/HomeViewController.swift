//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 07.10.2020.
//

import UIKit

class HomeViewController: UIViewController {
    
   private var advice = ["Задача сама себя не сделает!",
                         "Или ты задачу, или лень тебя!",
                         "Встань и делай!",
                         "Ты еще тут?",
                         "Хватит тыкать!",
                         "Move, Move, Move!",
                         "Сделал дело, сделай еще!",
                         "Лень хороша, когда ты спишь!",
                         "Поставил цель - делай!",
                         "Все проблемы в твоей голове!",
    ]
    
    //MARK: - Outlets
    
//    @IBOutlet weak var lastTaskLabel: UILabel!
    @IBOutlet weak private var stackWeather: UIStackView!
    @IBOutlet weak private var weatherLabel: UILabel!
    @IBOutlet weak private var stackAdvice:  UIStackView!
    @IBOutlet weak private var adviceLabel:  UILabel!
    @IBOutlet weak private var adviceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adviceLabel.textColor        = UIColor.init(hex: 0xd47c3f)
        weatherLabel.textColor       = UIColor.init(hex: 0xd47c3f)
        stackAdvice.backgroundColor  = UIColor.init(hex: 0xb5ebe5)
        stackWeather.backgroundColor = .clear
        view.setGradientBackground(colorOne: UIColor.init(hex: 0xb5ebe5), colorTwo: UIColor.init(hex: 0xffffff))
    }
    
//    @IBAction func lastTaskButtonPressed(_ sender: UIButton) {
//    }
    
    @IBAction private func adviceButtonPressed(_ sender: UIButton) {
        adviceLabel.text = advice.randomElement()
    }

  

    
    
}


