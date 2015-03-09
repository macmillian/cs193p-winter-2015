//
//  ViewController.swift
//  CalculatorBrain
//
//  Created by jrm on 3/7/15.
//  Copyright (c) 2015 Riesam LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var numberHasADecimalPoint = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        if let digit = sender.currentTitle{
            if( numberHasADecimalPoint && digit == "."){
                // do nothing additional decimal point is not allowed
            }else {
                if (digit == "."){
                    numberHasADecimalPoint = true
                }
                if userIsInTheMiddleOfTypingANumber {
                    display.text = display.text! + digit
                } else {
                    display.text = digit
                    userIsInTheMiddleOfTypingANumber = true
                }
            }
            println("digit = \(digit)")
            addToHistory(digit)
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        addToHistory(operation)
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        
    }
    
    @IBAction func clear(sender: UIButton) {
        display.text = "0"
        history.text = " "
        brain.clear()
        history.text = " "

    }
    
    func addToHistory(value: String) {
        if let oldText = history.text {
            history.text = oldText + " " + value
        }else {
            history.text = value
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

