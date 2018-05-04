//
//  Question.swift
//  Social Joy Take Two
//
//  Created by Addison G Hodges on 5/4/18.
//  Copyright © 2018 Addison G Hodges. All rights reserved.
//

import Foundation

class Question {
    var question : String
    var choices : [String : String] //key, value
    var answer : String
    var number : Int
    
    
    init(question: String, choices: [String : String], answer: String, number: Int) {
        self.question = question
        self.choices = choices
        self.answer = answer
        self.number = number
    }
}
