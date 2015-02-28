//
//  CalculatorBrain.swift
//  Kalkulator
//
//  Created by Zheng Hao Tan on 2/28/15.
//  Copyright (c) 2015 Zheng Hao Tan. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op : Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand) :
                    return "\(operand)"
                case .UnaryOperation(let symbol, _) :
                    return symbol
                case .BinaryOperation(let symbol, _) :
                    return symbol
                }
            }
        }
    }

    private var opStack = [Op]()
    
    private var knownOps = [String : Op]()
    
    init() {
        
        func learnOp(op : Op) {
            knownOps[op.description] = op;
        }
        learnOp(Op.BinaryOperation("✕", *));
        learnOp(Op.UnaryOperation("√", sqrt));
        learnOp(Op.BinaryOperation("+", +));
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
    }
    
    private func evaluate(ops : [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops;
            let op = remainingOps.removeLast();
            
            switch op {
            case .Operand(let operand) :
                return (operand, remainingOps)
            
            case .UnaryOperation(_, let operation) :
                let operandEvaluation = evaluate(remainingOps)

                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation) :
                let op1Evaluation = evaluate(remainingOps)
                
                if let op1 = op1Evaluation.result {
                    
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)

                    if let op2 = op2Evaluation.result {
                        return (operation(op1, op2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        
        // Remainder not needed.
        let (result, remainder) = evaluate(opStack)
        println("opstack: \(opStack) = \(result) with remainder \(remainder) left over")
        return result
    }

    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand));
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}