//
//  ViewController.swift
//  Kalkulator
//
//  Created by Zheng Hao Tan on 2/26/15.
//  Copyright (c) 2015 Zheng Hao Tan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber = false;
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!;
        
        if (userIsInTheMiddleOfTypingANumber) {
            display.text = display.text! + digit;
        }
        else {
            display.text = digit;
            userIsInTheMiddleOfTypingANumber = true;
        }

        println("digit: \(digit)");
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!;
        
        if userIsInTheMiddleOfTypingANumber {
            enter();
        }

        switch operation {
            
        case "✕": performOperation { $0 * $1 };
        case "÷": performOperation { $1 / $0 };
        case "+": performOperation { $0 + $1 };
        case "-": performOperation { $1 - $0 };
        case "√": performOperation { sqrt($0) };
        default: break;
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if (operandStack.count >= 2) {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast());
            enter();
        }
    }

    func performOperation(operation: Double -> Double) {
        if (operandStack.count >= 1) {
            displayValue = operation(operandStack.removeLast());
            enter();
        }
    }

    // Stack that stores the numbers
    var operandStack = Array<Double>();
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false;
        operandStack.append(displayValue);
        println("operandStack:  \(operandStack)");
    }

    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue;
        }
        set {
            display.text = "\(newValue)";
            userIsInTheMiddleOfTypingANumber = false;
        }
    }

}

