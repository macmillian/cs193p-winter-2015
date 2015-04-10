//
//  GraphView.swift
//  GraphingCalculator
//
//  Created by jrm on 4/5/15.
//  Copyright (c) 2015 Riesam LLC. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func pointsForGraphView(sender: GraphView) -> [CGPoint]
}


//struct GraphViewRange {
//    var min_x: Double
//    var max_x: Double
//}

@IBDesignable
class GraphView: UIView {

    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBInspectable var scale: CGFloat {
        get {
            return defaults.objectForKey("GraphViewController.Scale") as? CGFloat ?? contentScaleFactor
        }
        set {
            defaults.setObject(newValue, forKey: "GraphViewController.Scale")
            updateRange()
            setNeedsDisplay()
        }
    }
    
    var viewCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var axesOrigin: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            updateRange()
            setNeedsDisplay()
        }
    }
    
//    var pointsPerUnit: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    //range on x axis for which to request data points
    var range_min_x: CGFloat = -100.0
    var range_max_x:  CGFloat = 100.0
    //increment value for x points on axis
    var increment: CGFloat = 1.0
    
    func updateRange(){
        range_min_x = -axesOrigin.x / scale
        //println("In updateRange, axesOrigin.x: \(axesOrigin.x) bounds.size.width: \(bounds.size.width) range_min_x: \(range_min_x)" )
        
        range_max_x =  range_min_x + (bounds.size.width / scale)
        //println("In updateRange, axesOrigin.x: \(axesOrigin.x) bounds.size.width: \(bounds.size.width) range_max_x: \(range_max_x)" )
        
        increment = (1.0/scale)
        //println("In updateRange, scale: \(scale) increment value: \(increment) " )
        
    }
    

    
    // viewBounds passed to AxesDrawer
    private var viewBounds: CGRect {
        return CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: bounds.size
        )
    }
    

    
//    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.mainScreen().bounds.size)
    
    
    weak var dataSource: GraphViewDataSource?
    

    override func drawRect(rect: CGRect) {

        //println("In drawRect, scale = \(scale)")
        let axesDrawer = AxesDrawer(
            color: color,
            contentScaleFactor: contentScaleFactor
        )
        
        axesDrawer.drawAxesInRect(
            viewBounds,
            origin: axesOrigin,
            pointsPerUnit: scale
        )
        
        let path = UIBezierPath()

        path.lineWidth = lineWidth
        color.set()
        if var points = dataSource?.pointsForGraphView(self) {
            if(points.count > 1){
                let firstPoint = points.removeAtIndex(0);
                path.moveToPoint(firstPoint)
                for point in points {
                    path.addLineToPoint(point)
                }
                
            }
        }
        path.stroke()
        
        
    }
    
// MARK: - gestures

    func processPinch(gesture: UIPinchGestureRecognizer) {
        //println("entered GraphView.processPinch() ")
        if gesture.state == .Changed {
            //println("gesture.scale \(gesture.scale)")
            scale *= gesture.scale
            gesture.scale = 1.0
            
        }
    }
    
    func processPan(gesture: UIPanGestureRecognizer) {
        //println("entered GraphViewController.processPan() ")
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            let movementY = translation.y
            let movementX = translation.x
            if movementX != 0  || movementY != 0{
                
                axesOrigin.x += movementX
                axesOrigin.y += movementY
                gesture.setTranslation(CGPointZero, inView: self)
                
                //println("movementX \(movementX), movementY \(movementY)")
            }
            
        default: break
        }
        
    }
    
    func processTap(gesture: UITapGestureRecognizer){
        //println("entered GraphViewController.processTap() ")
        if gesture.state == .Ended {
            axesOrigin = gesture.locationInView(self)
        }
    }

}
