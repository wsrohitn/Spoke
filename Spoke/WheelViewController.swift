//
//  ViewController.swift
//  Spoke
//
//  Created by Rohit Natarajan on 20/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

class WheelViewController: UIViewController {
    var netTransactions: [String : NSDecimalNumber]?
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, netTransactions: [String: NSDecimalNumber], title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("WheelViewController") as? WheelViewController {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, netTransactions: netTransactions)
        }
    }
    
    func setInitialState(title: String, netTransactions: [String: NSDecimalNumber]) {
        self.title = title
        self.netTransactions = netTransactions
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let myTransactions = getTransactionsFor(self.title!)
//        let myNetTransactions = getNetTransactions(myTransactions, name: self.title!)
//        print(myNetTransactions)
        
        let wheel = Wheel(centerLabel: "DEF", spokes: netTransactions!)
        print(wheel.maxAmount)
        
        let wheelView = WheelView.makeInView(self.view, margin: 10, wheel: wheel)
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