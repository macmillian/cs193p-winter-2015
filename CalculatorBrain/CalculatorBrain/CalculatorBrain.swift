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
        case Constant(String, () -> Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, Int, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .Variable(let variable):
                        return variable
                    case .Constant(let symbol, _):
                        return symbol
                    case .UnaryOperation(let symbol, _):
                        return symbol
                    case .BinaryOperation(let symbol, _, _):
                        return symbol
                    default:
                        return ""
                }
            }
        }
        var precedence: Int {
            get {
                switch self {
                    case .BinaryOperation(_, let precedence, _):
                        return precedence
                    default:
                        return Int.max
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    var variableValues = Dictionary<String, Double>()
    
    private var error: String?
    
    init(){
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", 2, { $0 * $1 } ) )
        learnOp(Op.BinaryOperation("÷", 2, { $1 / $0 } ) )
        learnOp(Op.BinaryOperation("+", 1, { $0 + $1 } ) )
        learnOp(Op.BinaryOperation("−", 1, { $1 - $0 } ) )
        learnOp(Op.UnaryOperation("±", { $0 * -1.0 } ) )
        learnOp(Op.UnaryOperation("√", { sqrt($0) } ) )
        learnOp(Op.UnaryOperation("sin", { sin($0) } ) )
        learnOp(Op.UnaryOperation("cos", { cos($0) } ) )
        learnOp(Op.Constant("π", { M_PI } ) )
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
                    } else {
                        newOpStack.append(.Variable(opSymbol))
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
                    }else{
                        error = "Variable Not Found"
                    }
                    return (nil, remainingOps)
                case .Constant(_, let operation):
                    return (operation(), remainingOps)
                case .UnaryOperation(_,let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, _, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
                default:
                    return (nil,[])
            
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) =  \(result) with \(remainder) left over")
        println("variables \(variableValues) ")
        println("program \(program) ")
        return result
    }
    
    /*
         evaluate() except that if there is a problem of any kind evaluating the stack 
        (not just unset variables or missing operands, but also divide by zero, square root of a negative number, etc.), 
        instead of returning nil, it will return a String with what the problem is
    */
    func evaluateAndReportErrors() -> AnyObject? {
        let (result, _) = evaluate(opStack)
        return result != nil ? result : error
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
    }
    func removeLast() -> Double? {
        if(opStack.count > 0){
            opStack.removeLast()
        }
        return evaluate()
    }
    
    var description: String {
        get {
            var remainingOps = opStack
            var(desc, newRemainingOps, _) = describe(remainingOps)
            while(newRemainingOps.count > 0) {
                var(nextDesc, nextRemainingOps, _) = describe(newRemainingOps)
                desc = nextDesc + ", " + desc
                newRemainingOps = nextRemainingOps
            }

            return desc + " = "
        }
    }
    
    private func describe(ops: [Op]) -> (result: String, remainingOps: [Op], precedence: Int){
        //println("describing \(ops) ")
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return (operand.description, remainingOps, op.precedence)
                case .Variable(let key):
                    return (key, remainingOps, op.precedence)
                case .Constant(let symbol, _):
                    return (symbol, remainingOps, op.precedence)
                case .UnaryOperation(let symbol, _):
                    let (stringForRemainder,remainingOps, _) = describe(remainingOps)
                    return (symbol + "(" + stringForRemainder + ")", remainingOps, op.precedence)
                case .BinaryOperation(let symbol, let precedence, _):
                    var (stringForRemainder1,remainingOps1, precedence1) = describe(remainingOps)
                    var (stringForRemainder2,remainingOps2, precedence2) = describe(remainingOps1)
                    if(precedence > precedence1) {
                        stringForRemainder1 = "(" + stringForRemainder1 + ")"
                    }
                    if(precedence > precedence2) {
                        stringForRemainder2 =  "(" + stringForRemainder2 + ")"
                    }
                    return (stringForRemainder2 + symbol + stringForRemainder1, remainingOps2, precedence)
            
                default:
                    return ("", [], Int.max)
            }
        }
        return ("?", ops, Int.max)
    }
}
