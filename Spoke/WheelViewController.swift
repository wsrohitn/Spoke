//
//  ViewController.swift
//  Spoke
//
//  Created by Rohit Natarajan on 20/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

class WheelViewController: UIViewController {
    var wheel: Wheel?
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, wheel: Wheel, title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("WheelViewController") as? WheelViewController {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, wheel: wheel)
        }
    }
    
    func setInitialState(title: String, wheel: Wheel) {
        self.title = title
        self.wheel = wheel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(wheel!.spokes)
        print(wheel!.maxAmount)
        
        let wheelView = WheelView.makeInView(self.view, margin: 10, wheel: wheel!, addLabels: true)
        addTapToView(wheelView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addTapToView(view: UIView) {
        let tapgr = UITapGestureRecognizer(target: self, action: #selector(WheelViewController.tapView))
        view.addGestureRecognizer(tapgr)
    }
    
    func tapView() {
        let view = self.view
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            view.contentScaleFactor = (view.contentScaleFactor == 2.0 ? 1.0 : 2.0)
            view.transform = CGAffineTransformMakeScale(view.contentScaleFactor, view.contentScaleFactor)
        }, completion: nil)
    }
}