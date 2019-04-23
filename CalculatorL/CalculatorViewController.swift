//  Copyright © 2019 Olga Zimina. All rights reserved.

import UIKit

class CalculatorViewController: UIViewController {

  
    @IBOutlet weak var display: UILabel!
    
    private var displayValue: Double {
        
        get {
            return Double(display!.text!)!
        }
        
        set (new) {

//            OPTION 1
//            let fraction = new - Double(Int(new))
//            if fraction == 0 {
//                display.text = "\(Int(new))"
//            } else {
//                display.text = "\(new)"
//            }
    
//            OPTION 2
             let splitNumber = modf(new)
             if splitNumber.1 == 0 {
//                  display.text = "\(splitNumber.0)"
                display.text = format(this: splitNumber.0)
             } else {
//                 display.text = "\(new)"
                display.text = format(this: new)
             }
            isUserTypping = false
        }
    }
    var isUserTypping: Bool = false
    var isDotPlaced: Bool = false
    
    @IBAction func digitPressed(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        let currentTextOnDisplay = display!.text!
        
        if isUserTypping {
            
            display?.text = currentTextOnDisplay + digit
        } else {
            
            display?.text = digit
            isUserTypping = !isUserTypping
        }
    }
    
    var calculatorBrain = CalculatorModel()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if isUserTypping {
            
            calculatorBrain.setOperand(displayValue)
            isUserTypping = false
        }
        
        if let symbol = sender.currentTitle {
            
            calculatorBrain.performOperation(symbol)
        }
        
        if let result = calculatorBrain.result {
            
            displayValue = result
        }
    }
    
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        display.text = "0"
        isUserTypping = false
        isDotPlaced = false
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if isUserTypping && !isDotPlaced {
            display.text = display.text! + "."
            isDotPlaced = true
        } else if !isUserTypping && !isDotPlaced {
            display.text = "0."
            isUserTypping = true
        }
        
    }
}

func format(this: Double) -> String {
    
    let number = NSNumber(value: this)
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 10
    let numberFormatted = numberFormatter.string(from: number)
    return numberFormatted!
}
