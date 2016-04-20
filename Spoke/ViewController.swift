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

class ViewController: UIViewController {
    var spokeData: SpokeData?
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spokeData = SpokeData.init()
        print("number of transactions is", spokeData!.array.count)
        getAllNames()
        names.sortInPlace()
        print(names)
        
        let myTransaction = getTransactionsFor("DEF")
        let myNetTransactions = getNetTransactions(myTransaction, name: "DEF")
        print(myNetTransactions)
        
        print("m_2_pi is", M_2_PI)
        print("cos of that is", cos(M_2_PI))
        
        print("cos of 180 is", cos(180.0))
        print("m_pi is", M_PI)
        print("cos of pi is", cos(M_PI))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllNames() {
        let payers = spokeData?.array.map({$0.payer})
        let payees = spokeData?.array.map({$0.payee})
        
        for name in payers! {
            if !names.contains(name) {
                names.append(name)
            }
        }
        
        for name in payees! {
            if !names.contains(name) {
                names.append(name)
            }
        }
    }
    
    func getTransactionsFor(name: String) -> [Transaction] {
        var result = [Transaction]()
        
        for transaction in spokeData!.array {
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
            
            if netAmount.compare(NSDecimalNumber.zero()) != .OrderedSame {
                result[x] = netAmount
            }
        }
        
        return result
    }
}