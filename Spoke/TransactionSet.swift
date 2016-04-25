//
//  TransactionSet.swift
//  Spoke
//
//  Created by Rohit Natarajan on 25/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import Foundation
import WsBase
import WsCouchBasic

class TransactionSet {
    var transactions = [Transaction]()
    
//    func buildMonthSubSet( year : Int, month : Int ) -> TransactionSet
//    {
//        return buildSubSet( { $0.year == year && $0.month == month } )
//    }
    
    func buildSubSet( fn : (Transaction) -> Bool ) -> TransactionSet
    {
        let result = TransactionSet()
        result.transactions.appendContentsOf( transactions.filter( fn ) )
        return result
    }
    
    func getBrokerDataSet() -> [Ledger] {
        var result = [Ledger]()
        
        for t in transactions {
            if let w = findWheelForBroker( result, t: t) {
                w.add( t )
            } else {
                let w = makeWheelForBroker(t)
                result.append(w)
                w.add( t )
            }
        }
        for w in result {
            w.calcBalances()
        }
        return result
    }
    
    func findWheelForBroker(wheels: [Ledger], t: Transaction) -> Ledger? {
        for w in wheels {
            if w.currency == t.currency {
                if w.owner == t.broker {
                    return w
                }
            }
        }
        return nil
    }
    
    func makeWheelForBroker(t: Transaction) -> Ledger {
        let w = Ledger(owner: t.broker, currency: t.currency)
        return w
    }
    
    func getSyndicateDataSet() -> [Ledger] {
        var result = [Ledger]()
        
        for t in transactions {
            if let w = findWheelForSyndicate(result, t: t) {
                w.add( t )
            } else {
                let w = makeWheelForSyndicate(t)
                result.append(w)
                w.add( t )
            }
        }
        for w in result {
            w.calcBalances()        }
        return result
    }
    
    func findWheelForSyndicate(wheels: [Ledger], t: Transaction) -> Ledger? {
        for w in wheels {
            if w.currency == t.currency {
                if w.owner == t.syndicate {
                    return w
                }
            }
        }
        return nil
    }
    
    func makeWheelForSyndicate(t: Transaction) -> Ledger {
        let w = Ledger(owner: t.syndicate, currency: t.currency)
        return w
    }
    
    func loadData() {
        guard let db = SyncManager.sharedInstance.database, doc = db.existingDocumentWithID("SpokeTestData"), props = doc.properties else {
            return
        }
        transactions = []
        let datas = props.getArrayOfDictionaries("data")
        for data in datas {
            let amount = NSDecimalNumber(double: data.getDouble("amount"))
            transactions.append(Transaction(payer: data.getString("payer"), payee: data.getString("payee"), amount: amount, currency: data.getString("currency"), year: data.getInt("year"), month: data.getInt("month"), day: data.getInt("day")))
        }
        print("we have \(transactions.count) transactions")
    }
}
