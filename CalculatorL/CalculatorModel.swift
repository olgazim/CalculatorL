//  Copyright © 2019 Olga Zimina. All rights reserved.

import Foundation

enum Operation {
    
    case const(Double)
    case unaryOperation((Double) -> (Double))
    case binaryOperation((Double, Double) -> (Double))
    case equals
}

struct CalculatorModel {
    
    private var accumulator: Double?
    
    private var valuesDict: Dictionary<String,Operation> = [
        
        "π" : Operation.const(Double.pi),
        "℮" : Operation.const(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "+/-": Operation.unaryOperation{-$0},
        "𝑥^2": Operation.unaryOperation(squarePow),
        "%" : Operation.unaryOperation(convertToPercentage),
        "×" : Operation.binaryOperation{$0 * $1}, // если  функция последний аргумент () можно не писать
        "/" : Operation.binaryOperation{$0 / $1},
        "+" : Operation.binaryOperation({$0 + $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "𝑥^𝑛":Operation.binaryOperation(raiseToAPower),
        "=" : Operation.equals
    ]
    
    var result: Double? {
        
        return accumulator
    }
    private var currentInput: OperationWithTwoOperands?
    private struct OperationWithTwoOperands {
        let function: (Double, Double) -> Double
        let operandOne: Double

        func operate (with operandTwo: Double) -> Double {
            return function(operandOne, operandTwo)
        }
    }
    
    
    mutating func performOperation(_ symbol: String) {
        
        if let operation = valuesDict[symbol] {
            
            switch operation {
                
            case .const(let value):
                
                accumulator = value
                
            case .unaryOperation(let function):
                
                if accumulator != nil {
                    
                    accumulator = function(accumulator!)
                }
            
            case .binaryOperation(let function):
                
                if accumulator != nil {
                    performOperation()
                    currentInput = OperationWithTwoOperands(function: function, operandOne: accumulator!)
                    accumulator = nil
                }
            
            case .equals:
                performOperation()
            }
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        
        accumulator = operand
    }
    
    
    mutating func performOperation() {
        if accumulator != nil && currentInput != nil {
            
            accumulator = currentInput?.operate(with: accumulator!)
            currentInput = nil
        }
    }
    
}

func squarePow(operand: Double) -> Double{
    return operand * operand
}

func convertToPercentage(operand: Double) -> Double{
    return operand / 100
}

func raiseToAPower (operandOne: Double, operandTwo: Double) -> Double {
    var result = operandOne
    let operandTwoConverted: Int = Int (operandTwo)
    
    if operandTwoConverted == 0 {
        return 1
    } else if operandTwoConverted < 0{
        var i: Int = 1
        result = 1
        while i <= (operandTwoConverted * (-1)){
            result = result / operandOne
            i += 1
        }
        return result
    } else  {
        var i: Int = 2
        while i <= operandTwoConverted{
            result = result * operandOne
            i += 1
        }
        return result
    }
}

