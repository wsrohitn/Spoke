//
//  ViewController.swift
//  Spoke
//
//  Created by Rohit Natarajan on 20/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

struct Transaction {
    let payer: String
    let payee: String
    let amount: NSDecimalNumber
    let currency: String
    let year: Int
    let month: Int
    let day: Int
}

class WheelViewController: UIViewController {
    var transactions: [Transaction]?
    var names = [String]()
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, transactions: [Transaction], title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("WheelViewController") as? WheelViewController {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, transactions: transactions)
        }
    }
    
    func setInitialState(title: String, transactions: [Transaction]) {
        self.title = title
        self.transactions = transactions
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllNames()
        names.sortInPlace()
        let myTransactions = getTransactionsFor(self.title!)
        let myNetTransactions = getNetTransactions(myTransactions, name: self.title!)
        print(myNetTransactions)
        
        let wheel = Wheel(centerLabel: "DEF", spokes: myNetTransactions)
        print(wheel.maxAmount)
        
        let wheelView = WheelView.makeInView(self.view, margin: 10, wheel: wheel)
        addTapToView(wheelView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAllNames() {
        let payers = transactions!.map({$0.payer})
        let payees = transactions!.map({$0.payee})
        
        for name in payers {
            if !names.contains(name) {
                names.append(name)
            }
        }
        
        for name in payees {
            if !names.contains(name) {
                names.append(name)
            }
        }
    }
    
    func getTransactionsFor(name: String) -> [Transaction] {
        var result = [Transaction]()
        
        for transaction in transactions! {
            if transaction.payee == name || transaction.payer == name {
                result.append(transaction)
            }
        }
        
        return result
    }
    
    func getNetTransactions(transactions: [Transaction], name: String) -> [String: NSDecimalNumber] {
        var result = [String: NSDecimalNumber]()
        
        let myOutgoing = transactions.filter({$0.payer == name})
        let myIncoming = transactions.filter({$0.payer != name})
        
        for x in names where x != name {
            let outgoingToX = myOutgoing.filter({ $0.payee == x})
            let incomingFromX = myIncoming.filter({ $0.payer == x})
            
            let outgoingAmount = outgoingToX.map({$0.amount}).reduce(NSDecimalNumber.zero(), combine: { $0.decimalNumberBySubtracting($1) })
            let incomingAmount = incomingFromX.map({$0.amount}).reduce(NSDecimalNumber.zero(), combine: { $0.decimalNumberByAdding($1) })
            let netAmount = incomingAmount.decimalNumberByAdding(outgoingAmount)
            
//            if netAmount.compare(NSDecimalNumber.zero()) != .OrderedSame {
                result[x] = netAmount
//            }
        }
        
        return result
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