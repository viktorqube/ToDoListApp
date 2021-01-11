//
//  ChuckNorrisSetup.swift
//  ToDoListApp
//
//  Created by Viktor Qube on 22.12.2020.
//


import Foundation
import UIKit

struct Quotes: Decodable {
    var value: String
}

protocol QuotesRendareble {
    var quote: String {get}
}

extension Quotes: QuotesRendareble {
    var quote: String {
        return value
    }
    
    
}
