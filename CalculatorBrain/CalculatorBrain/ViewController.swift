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
    
    @IBAction func back(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if countElements(display.text!) > 0 {
                var text = display.text!
                text = dropLast(text)
                if countElements(text) > 0 {
                    display.text = text
                }else{
                    display.text = " "
                }
            }
        }else{
            //remove last item from program/brain opStack
            if let result = brain.removeLast() {
                displayValue = result
            } else {
                displayValue = 0
            }
            updateUI()
            
        }
    }
    
    @IBAction func plusMinus(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            //change the sign of the number and allow typing to continue
            var text = display.text!
            if(text[text.startIndex] == "-"){
                display.text = dropFirst(text)
            }else{
                display.text = "-" + text
            }
        }else{
            operate(sender)
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        if let digit = sender.currentTitle{
            if( numberHasADecimalPoint && digit == "."){
                // do nothing additional decimal point is not allowed
            }else {
                if (digit == "."){
                    numberHasADecimalPoint = true
                }
                if userIsInTheMiddleOfTypingANumber {
                    var text = display.text!
                    if(text[text.startIndex] == "0"){
                        text = dropFirst(text)
                    }
                    display.text = display.text! + digit
                } else {
                    display.text = digit
                    userIsInTheMiddleOfTypingANumber = true
                }
            }
            println("digit = \(digit)")
        }
        updateUI()
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        updateUI()
    }
    
    @IBAction func clear(sender: UIButton) {
        display.text = " "
        brain.clear()
        brain.variableValues.removeValueForKey("M")
        
        updateUI()

    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = displayValue{
            if let result = brain.pushOperand(value) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }else {
            displayValue = nil
        }
        
        updateUI()
    }

    
    @IBAction func saveMemory() {
        if let value = displayValue {
            brain.variableValues["M"] = value
        }
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.evaluate() {
            displayValue = result
        } else {
            displayValue = nil
        }
        updateUI()
    }
    
    @IBAction func loadMemory() {
        if let result = brain.pushOperand("M") {
            displayValue = result
        } else {
            displayValue = nil
        }
        updateUI()
    }


    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if let value = newValue{
                display.text = "\(value)"
            } else {
                if let result = brain.evaluateAndReportErrors() as? String {
                    display.text = result
                } else {
                    display.text = " "
                }
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    func updateUI(){
        history.text = brain.description
    }
}

