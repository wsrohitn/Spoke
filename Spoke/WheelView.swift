//
//  Wheel.swift
//  Spoke
//
//  Created by Rohit Natarajan on 20/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

@IBDesignable
class WheelView: UIView {
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        UIColor.lightGrayColor().setFill()
        path.fill()
        
//        let linePath = UIBezierPath()
//        linePath.moveToPoint(CGPoint(x: bounds.width/2, y: bounds.height/2))
        //linePath.addLineToPoint(CGPoint(x: 0, y: 120))
//        linePath.addLineToPoint(CGPoint(x: 120 + 120 * cos(M_PI) , y: 120 + 120 * sin(M_PI)))
//        linePath.stroke()
        UIColor.blackColor().setStroke()
        
        let paths = getNPaths(12)
        for path in paths {
            path.stroke()
        }
    }
    
    func getNPaths(num: Int) -> [UIBezierPath] {
        var result = [UIBezierPath]()
        let r = Double(bounds.width/2)
        
        for i in 0 ..< num {
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: bounds.width/2, y: bounds.height/2))
            let tmp = Double(i) * Double(2) * M_PI / Double(num)
            let point = CGPoint(x: r + r * cos(tmp), y: r + r * sin(tmp) )
            
            let label = UILabel(frame: self.frame)
            label.center = point
            label.textAlignment = NSTextAlignment.Center
            label.text = "I'am a test label"
            super.addSubview(label)
            
            path.addLineToPoint(point)
            
            result.append(path)
        }
        
        return result
    }
    
}
