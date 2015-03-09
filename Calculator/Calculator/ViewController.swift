//
//  ViewController.swift
//  Calculator
//
//  Created by jrm on 3/5/15.
//  Copyright (c) 2015 Riesam LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var numberHasADecimalPoint = false
    
    
    @IBAction func appendDigit(sender: UIButton) {
        if let digit = sender.currentTitle{
            if( numberHasADecimalPoint && digit == "."){
                // do nothing; additional decimal point is not allowed
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
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π":
                displayValue =  M_PI
                enter()
        default: break
        }
        
    }
    
    @IBAction func clear(sender: UIButton) {
        display.text = "0"
        history.text = " "
        operandStack.removeAll()
        history.text = " "
        println("operandStack = \(operandStack)")
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func addToHistory(value: String) {
        if let oldText = history.text {
            history.text = oldText + " " + value
        }else {
            history.text = value
        }
    }
    
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        numberHasADecimalPoint = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
        
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
