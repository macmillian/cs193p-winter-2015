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
    
    @IBAction func back(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if countElements(display.text!) > 0 {
                var text = display.text!
                text = dropLast(text)
                if countElements(text) > 0 {
                    display.text = text
                }else{
                    display.text = "0"
                }
            }
        }

        addToHistory("🔙")
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
            addToHistory("±")
        }else{
            operate(sender)
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        
        if let digit = sender.currentTitle{
            if( numberHasADecimalPoint && digit == "."){
                // do nothing; additional decimal point is not allowed
            }else {
                if (digit == "."){
                    numberHasADecimalPoint = true
                }
                if userIsInTheMiddleOfTypingANumber {
                    var text = display.text!
                    if(text[text.startIndex] == "0"){
                        text = dropFirst(text)
                    }
                    display.text = text + digit
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
            performEnter("")
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
                //enter()
                performEnter("constant")
        case "±": performOperation { $0 * -1 }
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
            performEnter("operation")
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            performEnter("operation")
            //enter()
        }
    }
    
    func addToHistory(value: String) {
        if let oldText = history.text {
            history.text = oldText + " " + value
        }else {
            history.text = value
        }
        //get rid of any extra = chars
        if let historyText = history.text {
            let endIndex = advance(historyText.endIndex, -1)
            let range = Range(start: historyText.startIndex, end: endIndex)
            let newhistory = historyText.stringByReplacingOccurrencesOfString(
                " =",
                withString: "",
                options: nil,
                range: range)
            history.text = newhistory
        }
        
    }
    
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        performEnter("enterButtonClicked")
    }
    
    func performEnter(type: String){
        switch(type){
            case "operation":
                addToHistory("=")
            case "enterButtonClicked":
                addToHistory("⏎")
            case "contant":
                addToHistory("⏎")
            default:
                break
        }
        userIsInTheMiddleOfTypingANumber = false
        numberHasADecimalPoint = false
        if let value = displayValue{
            operandStack.append(value)
        }else {
            displayValue = 0
        }
        println("operandStack = \(operandStack)")
        
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            if let value = newValue{
                display.text = "\(value)"
            }else{
                display.text = "0"
            }
            //display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}
