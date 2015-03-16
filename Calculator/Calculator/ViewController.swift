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
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit.rangeOfString(".") != nil ? "0" + digit : digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            display.text = dropLast(display.text!)
            if countElements(display.text!) == 0 {
                displayValue = 0
            }
        }
    }
    
    @IBAction func clear() {
        brain.clear();
        userIsInTheMiddleOfTypingANumber = false
        displayValue = 0
        history.text = ""
    }
    
    @IBAction func operate(sender: UIButton) {
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
        history.text = brain.description
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
        history.text = brain.description
    }
    
    var displayValue: Double? {
        get {
            if let displayValueAsDouble = NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
                return displayValueAsDouble
            }
            return nil
        }
        set {
            display.text = newValue != nil ? "\(newValue!)" : " " // Show error?
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}