//
//  Transaction.swift
//  Spoke
//
//  Created by Rohit Natarajan on 22/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import Foundation

struct Transaction {
    let payer: String
    let payee: String
    let amount: NSDecimalNumber
    let currency: String
    let year: Int
    let month: Int
    let day: Int
}

class TransactionFuncs {
    static func getAllNames(transactions: [Transaction]) -> [String] {
        let payers = transactions.map({$0.payer})
        let payees = transactions.map({$0.payee})
        var names = [String]()
        
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
        
        return names
    }
    
    static func getSyndNames(transactions: [Transaction]) -> [String] {
        var result = [String]()
        let names = TransactionFuncs.getAllNames(transactions)
        
        for name in names {
            if let _ = Int(name.substringFromIndex( name.startIndex.successor()))  {
                result.append(name)
            }
        }
        
        return result
    }
    
    static func getBrokerNames(transactions: [Transaction]) -> [String] {
        var result = [String]()
        let names = TransactionFuncs.getAllNames(transactions)
        let synds = TransactionFuncs.getSyndNames(transactions)
        
        for name in names {
            if !synds.contains(name) {
                result.append(name)
            }
        }
        
        return result
    }
    
    static func getTransactionsFor(transactions: [Transaction], name: String) -> [Transaction] {
        var result = [Transaction]()
        
        for transaction in transactions {
            if transaction.payee == name || transaction.payer == name {
                result.append(transaction)
            }
        }
        
        return result
    }
    
    static func getNetTransactions(transactions: [Transaction], name: String) -> [String: NSDecimalNumber] {
        var result = [String: NSDecimalNumber]()
        
        let myOutgoing = transactions.filter({$0.payer == name})
        let myIncoming = transactions.filter({$0.payer != name})
        
        let syndNames = TransactionFuncs.getSyndNames(transactions)
        let brokerNames = TransactionFuncs.getBrokerNames(transactions)
        
        let names = syndNames.contains(name) ? brokerNames : syndNames
        
        for x in names where x != name {
            let outgoingToX = myOutgoing.filter({ $0.payee == x})
            let incomingFromX = myIncoming.filter({ $0.payer == x})
            
            let outgoingAmount = outgoingToX.map({$0.amount}).reduce(NSDecimalNumber.zero(), combine: { $0.decimalNumberBySubtracting($1) })
            let incomingAmount = incomingFromX.map({$0.amount}).reduce(NSDecimalNumber.zero(), combine: { $0.decimalNumberByAdding($1) })
            let netAmount = incomingAmount.decimalNumberByAdding(outgoingAmount)
            
            result[x] = netAmount
        }
        
        return result
    }
}

