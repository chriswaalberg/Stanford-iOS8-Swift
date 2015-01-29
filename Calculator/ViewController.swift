//
//  ViewController.swift
//  Calculator
//
//  Created by Chris Waalberg on 27/01/15.
//  Copyright (c) 2015 Q42. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var dotShouldBeAppended = false
    
    @IBAction func appendDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        if dotShouldBeAppended {
            digit = "." + digit
            dotShouldBeAppended = false
        }
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            if digit.rangeOfString(".") != nil {
                digit = "0" + digit
            }
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendDot() {
        if !userIsInTheMiddleOfTypingANumber || display.text!.rangeOfString(".") == nil {
            dotShouldBeAppended = true
        }
    }
    
    @IBAction func clear() {
        enter()
        display.text = "0"
        history.text = ""
        operandStack.removeAll()
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        history.text! += operation + "\n"
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "-": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation(M_PI)
        default: break
        }
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
    
    func performOperation(value: Double) {
        displayValue = value
        enter()
    }
    
    var operandStack = [Double]()
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber {
            history.text! += display.text! + "\n"
        }
        userIsInTheMiddleOfTypingANumber = false
        dotShouldBeAppended = false
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