//
//  CalculatorBrainTests.swift
//  CalculatorBrainTests
//
//  Created by jrm on 3/7/15.
//  Copyright (c) 2015 Riesam LLC. All rights reserved.
//

import UIKit
import XCTest
import CalculatorBrain

class CalculatorBrainTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testDescription() {
        // 7a: 10 cos -> cos(10)
        var brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(10)!, 10)
        XCTAssertGreaterThan(brain.performOperation("cos")!, -0.83907152908)
        XCTAssertLessThan(brain.evaluate()!, -0.83907152906)
        XCTAssertEqual(brain.description, "cos(10.0) = ")
        
        // 7b: 3 - 5
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertEqual(brain.pushOperand(5)!, 5)
        XCTAssertEqual(brain.performOperation("−")!, -2)
        XCTAssertEqual(brain.description, "3.0−5.0 = ")
        
        // 7c: 23.5
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(23.5)!, 23.5)
        XCTAssertEqual(brain.description, "23.5 = ")
        
        // 7c: π
        brain = CalculatorBrain()
        XCTAssertEqual(brain.performOperation("π")!, M_PI)
        XCTAssertEqual(brain.description, "π = ")
        
        // 7c: x
        brain = CalculatorBrain()
        XCTAssertNil(brain.pushOperand("x"))
        XCTAssertEqual(brain.description, "x = ")
        
        // 7d: 10 √ 3 + -> √(10) + 3
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(10)!, 10)
        XCTAssertTrue(brain.performOperation("√")! - 3.162 < 0.1)
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertTrue(brain.performOperation("+")! - 6.162 < 0.1)
        XCTAssertEqual(brain.description, "√(10.0)+3.0 = ")
        
//        // 7d: 3 ↲ 5 + √ ⇒ √(3+5)
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertEqual(brain.pushOperand(5)!, 5)
        XCTAssertEqual(brain.performOperation("+")!, 8)
        XCTAssertTrue(brain.performOperation("√")! - 2.828 < 0.1)
        XCTAssertEqual(brain.description, "√(3.0+5.0) = ")
        
//        // 7d: 3 ↲ 5 ↲ 4 + + ⇒3+(5+4)or (for Extra Credit)3+5+4
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertEqual(brain.pushOperand(5)!, 5)
        XCTAssertEqual(brain.pushOperand(4)!, 4)
        XCTAssertEqual(brain.performOperation("+")!, 9)
        XCTAssertEqual(brain.performOperation("+")!, 12)
        XCTAssertEqual(brain.description, "3.0+5.0+4.0 = ")
        
//        // 7d: 3 ↲ 5 √ + √ 6 ÷ ⇒ √(3+ √(5))÷6
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertEqual(brain.pushOperand(5)!, 5)
        XCTAssertTrue(brain.performOperation("√")! - 2.236 < 0.1)
        XCTAssertTrue(brain.performOperation("+")! - 5.236 < 0.1)
        XCTAssertTrue(brain.performOperation("√")! - 2.288 < 0.1)
        XCTAssertEqual(brain.pushOperand(6)!, 6)
        XCTAssertTrue(brain.performOperation("÷")! - 0.381 < 0.1)
        XCTAssertEqual(brain.description, "√(3.0+√(5.0))÷6.0 = ")
        
        // 7e: 3 ↲ + ⇒ ?+3.
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertNil(brain.performOperation("+"))
        XCTAssertEqual(brain.description, "?+3.0 = ")
        
        // 7f: 3 ↲ 5 + √ π cos ⇒ √(3+5),cos(π).
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertEqual(brain.pushOperand(5)!, 5)
        XCTAssertEqual(brain.performOperation("+")!, 8)
        XCTAssertTrue(brain.performOperation("√")! - 2.828 < 0.1)
        XCTAssertEqual(brain.performOperation("π")!, M_PI)
        XCTAssertEqual(brain.performOperation("cos")!, -1)
        XCTAssertEqual(brain.description, "√(3.0+5.0), cos(π) = ")
        
        // 7g: 3 ↲ 5 ↲ 4 + * must not output 3*5+4—it must be 3*(5+4)
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertEqual(brain.pushOperand(5)!, 5)
        XCTAssertEqual(brain.pushOperand(4)!, 4)
        XCTAssertEqual(brain.performOperation("+")!, 9)
        XCTAssertEqual(brain.performOperation("×")!, 27)
        XCTAssertEqual(brain.description, "3.0×(5.0+4.0) = ")
        
        // 9f:  7 M + √ ⇒ description is √(7+M), display is blank because M is not set
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(7)!, 7)
        brain.pushOperand("M")
        brain.performOperation("+")
        brain.performOperation("√")
        XCTAssertEqual(brain.description, "√(7.0+M) = ")
        
        // 9f: 9 →M ⇒ display now shows 4 (the square root of 16), description is still √(7+M)
        brain.variableValues["M"] = 9
        XCTAssertEqual(brain.evaluate()!, 4)
        XCTAssertEqual(brain.description, "√(7.0+M) = ")
        
        // 9f: 14 + ⇒ display now shows 18, description is now √(7+M)+14
        brain.pushOperand(14)
        XCTAssertEqual(brain.performOperation("+")!, 18)
        XCTAssertEqual(brain.description, "√(7.0+M)+14.0 = ")

    }
}
