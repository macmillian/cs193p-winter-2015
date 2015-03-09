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
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let variable):
                    return variable
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
    
    var variableValues = Dictionary<String, Double>()
    
    private var error: String?
    
    private var lastOp = Op?()
    
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
        learnOp(Op.UnaryOperation("π", { M_PI * $0 } ) )
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
            case .Variable(let key):
                if let value = variableValues[key] {
                    return (value, remainingOps)
                }
                error = "Variable Not Found in Dictionary"
                return (nil, remainingOps)
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
        println("variables \(variableValues) ")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear(){
        opStack.removeAll()
        variableValues = Dictionary<String, Double>()
        lastOp = nil
    }
    
    var description: String {
        get {
            var desc: String = ""
            for thing in opStack {
                desc += " \(thing) "
            }
            return desc + " = "
        }
    }
}
