//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by jrm on 3/6/15.
//  Copyright (c) 2015 Riesam LLC. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    init(){
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", { $0 * $1 } ) )
        learnOp(Op.BinaryOperation("÷", { $1 / $0 } ) )
        learnOp(Op.BinaryOperation("+", { $0 + $1 } ) )
        learnOp(Op.BinaryOperation("−", { $1 - $0 } ) )
        learnOp(Op.UnaryOperation("√", { sqrt($0) } ) )
        learnOp(Op.UnaryOperation("sin", { sin($0) } ) )
        learnOp(Op.UnaryOperation("cos", { cos($0) } ) )
        learnOp(Op.UnaryOperation("tan", { tan($0) } ) )
//        learnOp(Op.UnaryOperation("±", { -$0 }, nil))
//        learnOp(Op.NullaryOperation("π", { M_PI }))
//        learnOp(Op.NullaryOperation("e", { M_E }))
    }
    
    var program: AnyObject { // guaranteed to be a PropertyList
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_,let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_,let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) =  \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
