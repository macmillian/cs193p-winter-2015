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
        // a: 10 cos -> cos(10)
        var brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(10)!, 10)
        XCTAssertGreaterThan(brain.performOperation("cos")!, -0.83907152908)
        XCTAssertLessThan(brain.evaluate()!, -0.83907152906)
        //XCTAssertEqual(brain.description, "cos(10)")
        
        // b: 3 - 5
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(3)!, 3)
        XCTAssertEqual(brain.pushOperand(5)!, 5)
        XCTAssertEqual(brain.performOperation("−")!, -2)
//        XCTAssertEqual(brain.description, "3 − 5")
        
        // c: 23.5
        brain = CalculatorBrain()
        XCTAssertEqual(brain.pushOperand(23.5)!, 23.5)
        //XCTAssertEqual(brain.description, "23.5")
        
        // c: π
//        brain = CalculatorBrain()
//        XCTAssertEqual(brain.performOperation("π")!, M_PI)
        //XCTAssertEqual(brain.description, "π")
        
        // c: x
        brain = CalculatorBrain()
        XCTAssertNil(brain.pushOperand("x"))
//        XCTAssertEqual(brain.description, "x")
        
        // d: 10 √ 3 + -> √(10) + 3
//        brain = CalculatorBrain()
//        XCTAssertEqual(brain.pushOperand(10)!, 10)
//        XCTAssertTrue(brain.performOperation("√")! - 3.162 < 0.1)
//        XCTAssertEqual(brain.pushOperand(3)!, 3)
//        XCTAssertTrue(brain.performOperation("+")! - 6.162 < 0.1)
//        //XCTAssertEqual(brain.description, "√(10) + 3")
//        XCTAssertEqual(brain.description, "√10 + 3")
        
//        // d: 3 ↲ 5 + √ ⇒ √(3+5)
//        brain = CalculatorBrain()
//        XCTAssertEqual(brain.pushOperand(3)!, 3)
//        XCTAssertEqual(brain.pushOperand(5)!, 5)
//        XCTAssertEqual(brain.performOperation("+")!, 8)
//        XCTAssertTrue(brain.performOperation("√")! - 2.828 < 0.1)
//        XCTAssertEqual(brain.description, "√(3 + 5)")
        
//        // d: 3 ↲ 5 ↲ 4 + + ⇒3+(5+4)or (for Extra Credit)3+5+4
//        brain = CalculatorBrain()
//        XCTAssertEqual(brain.pushOperand(3)!, 3)
//        XCTAssertEqual(brain.pushOperand(5)!, 5)
//        XCTAssertEqual(brain.pushOperand(4)!, 4)
//        XCTAssertEqual(brain.performOperation("+")!, 9)
//        XCTAssertEqual(brain.performOperation("+")!, 12)
//        //XCTAssertEqual(brain.description, "3 + (5 + 4)")
//        XCTAssertEqual(brain.description, "3 + 5 + 4")
        
//        // d: 3 ↲ 5 √ + √ 6 ÷ ⇒ √(3+ √(5))÷6
//        brain = CalculatorBrain()
//        XCTAssertEqual(brain.pushOperand(3)!, 3)
//        XCTAssertEqual(brain.pushOperand(5)!, 5)
//        XCTAssertTrue(brain.performOperation("√")! - 2.236 < 0.1)
//        XCTAssertTrue(brain.performOperation("+")! - 5.236 < 0.1)
//        XCTAssertTrue(brain.performOperation("√")! - 2.288 < 0.1)
//        XCTAssertEqual(brain.pushOperand(6)!, 6)
//        XCTAssertTrue(brain.performOperation("÷")! - 0.381 < 0.1)
//        //XCTAssertEqual(brain.description, "√(3 + √(5)) ÷ 6")
//        XCTAssertEqual(brain.description, "√(3 + √5) ÷ 6")
        
//        // e: 3 ↲ + ⇒ ?+3.
//        brain = CalculatorBrain()
//        XCTAssertEqual(brain.pushOperand(3)!, 3)
//        XCTAssertNil(brain.performOperation("+"))
//        XCTAssertEqual(brain.description, "? + 3")
        
//        // f: 3 ↲ 5 + √ π cos ⇒ √(3+5),cos(π).
//        brain = CalculatorBrain()
//        XCTAssertEqual(brain.pushOperand(3)!, 3)
//        XCTAssertEqual(brain.pushOperand(5)!, 5)
//        XCTAssertEqual(brain.performOperation("+")!, 8)
//        XCTAssertTrue(brain.performOperation("√")! - 2.828 < 0.1)
//        XCTAssertEqual(brain.performOperation("π")!, M_PI)
//        XCTAssertEqual(brain.performOperation("cos")!, -1)
//        //XCTAssertEqual(brain.description, "√(3 + 5), cos(π)")
//        XCTAssertEqual(brain.description, "√(3 + 5), cosπ")
        
        // g: 3 ↲ 5 ↲ 4 + * must not output 3*5+4—it must be 3*(5+4)
//        brain = CalculatorBrain()
//        XCTAssertEqual(brain.pushOperand(3)!, 3)
//        XCTAssertEqual(brain.pushOperand(5)!, 5)
//        XCTAssertEqual(brain.pushOperand(4)!, 4)
//        XCTAssertEqual(brain.performOperation("+")!, 9)
//        XCTAssertEqual(brain.performOperation("×")!, 27)
//        XCTAssertEqual(brain.description, "3 × (5 + 4)")

    }
}
