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
    
    func getBrokerDataSet() -> [Wheel] {
        var result = [Wheel]()
        
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
            w.calcSpokes()
        }
        return result
    }
    
    func findWheelForBroker(wheels: [Wheel], t: Transaction) -> Wheel? {
        for w in wheels {
            if w.currency == t.currency {
                if w.centerLabel == t.broker {
                    return w
                }
            }
        }
        return nil
    }
    
    func makeWheelForBroker(t: Transaction) -> Wheel {
        let w = Wheel(centerLabel: t.broker, currency: t.currency)
        return w
    }
    
    func findWheelForSyndicate(wheels: [Wheel], t: Transaction) -> Wheel? {
        for w in wheels {
            if w.currency == t.currency {
                if w.centerLabel == t.syndicate {
                    return w
                }
            }
        }
        return nil
    }
    
    func makeWheelForSyndicate(t: Transaction) -> Wheel {
        let w = Wheel(centerLabel: t.syndicate, currency: t.currency)
        return w
    }
    
//    func getForGrouping( g : Grouping ) -> [Wheel]
//    {
//        var result = [Wheel]()
//
//        for t in transactions {
//            if let w = findRelevantWheel( resuilt, t, g ) {
//                w.add( t )
//            } else {
//                let w = makeRelevantWheel( t, g )
//                result.add( w )]
//                w.add( t )
//            }
//        }
//        return result
//    }

    
    func getSyndicateDataSet() -> [Wheel] {
        var result = [Wheel]()
        
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
            w.calcSpokes()
        }
        return result
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
