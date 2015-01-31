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
    
    var brain = CalculatorBrain()
    
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
//        enter()
//        display.text = "0"
//        history.text = ""
//        operandStack.removeAll()
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0 // TODO: Show error by making displayValue into an Optional
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        dotShouldBeAppended = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0 // TODO: Show error by making displayValue into an Optional
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