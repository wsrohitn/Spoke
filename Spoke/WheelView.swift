//
//  Wheel.swift
//  Spoke
//
//  Created by Rohit Natarajan on 20/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

//@IBDesignable
class WheelView: UIView {
    
    var circlePathLayer = CAShapeLayer()
    var wheel: Wheel = Wheel(centerLabel: "", currency: "")
    
    init(frame: CGRect, wheel: Wheel) {
        super.init(frame: frame)
        drawCircle()
        self.wheel = wheel
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        drawCircle()
    }
    
    class func makeInView(view: UIView, margin: CGFloat = 0.0, wheel: Wheel, addLabels: Bool = false) -> WheelView {
        let fMain = view.frame
        var w = fMain.width
        if fMain.width > fMain.height {
            w = fMain.height
        }
        w = w - 2 * margin
        
        let f  = CGRectMake( (fMain.width - w )/2, (fMain.height - w )/2, w, w)
        let wheelView = WheelView(frame: f, wheel: wheel)
        wheelView.displayWheel( addLabels )
        
        view.addSubview(wheelView)
        return wheelView
    }

    
    func drawCircle() {
        circlePathLayer.frame = bounds
        circlePathLayer.path = UIBezierPath(ovalInRect: circlePathLayer.frame).CGPath
        circlePathLayer.fillColor = UIColor.lightGrayColor().CGColor
        circlePathLayer.backgroundColor = UIColor.clearColor().CGColor
        layer.addSublayer(circlePathLayer)
    }
    
    func displayWheel( addLabels : Bool ){
        var idx = 0
        for spoke in wheel.spokes
        {
            if spoke.amount != NSDecimalNumber.zero() {
                let theta = calculateAngle(idx, num: wheel.spokes.count)
                let path = getPath(theta, amount: spoke.amount.decimalNumberByDividingBy(wheel.maxAmount))
                addPath(path, negate: spoke.amount.doubleValue < 0.0)
                if addLabels {
                    addLabel( theta, str : spoke.otherParty )
                }
            }
            idx = idx + 1
        }
    }
    
    func getPath(theta: Double, amount: NSDecimalNumber) -> UIBezierPath {
        let r = Double(bounds.width/2)
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: bounds.width, y: bounds.height))
        let amp = abs( Double(amount) )
        let point = CGPoint(x: 2*r + amp * r * cos(theta), y: 2*r + amp * r * sin(theta) )
        path.addLineToPoint(point)
        return path
    }
    
    func calculateAngle(i: Int, num: Int) -> Double {
        return Double(i) * Double(2) * M_PI / Double(num)
    }
    
    func addPath(path: UIBezierPath, negate: Bool) {
        let pathLayer = CAShapeLayer()
        pathLayer.bounds = circlePathLayer.bounds
        pathLayer.path = path.CGPath
        pathLayer.lineWidth = 3.0
        pathLayer.strokeColor = negate ? UIColor.redColor().CGColor : UIColor.greenColor().CGColor
        circlePathLayer.addSublayer(pathLayer)
    }
    
    func addLabel( theta : Double, str : String )
    {
        let r = Double(bounds.width/2)
        let point = CGPoint(x: r + r * cos(theta), y: r + r * sin(theta) )
        
        let label = UILabel(frame: self.frame)
        label.center = point
        label.textAlignment = NSTextAlignment.Center
        label.text = str
        self.addSubview(label)
    }
}
