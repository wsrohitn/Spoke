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
        var names = [String]()
        
        for transaction in transactions {
            let payee = transaction.payee
            let payer = transaction.payer
            
            if !names.contains(payee) {
                names.append(payee)
            }
            
            if !names.contains(payer) {
                names.append(payer)
            }
        }
        names.sortInPlace()
        return names
    }
    
    static func getSyndAndBrokerNames(names: [String]) -> (syndNames: [String], brokerNames: [String]) {
        var syndNames = [String]()
        var brokerNames = [String]()
        
        
        for name in names {
            if let _ = Int(name.substringFromIndex( name.startIndex.successor()))  {
                syndNames.append(name)
            } else {
                brokerNames.append(name)
            }
        }
        syndNames.sortInPlace()
        brokerNames.sortInPlace()
        return (syndNames, brokerNames)
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
    
    static func getNetTransactions(transactions: [Transaction], name: String, currency: String) -> [String: NSDecimalNumber] {
        var result = [String: NSDecimalNumber]()

        let myOutgoing = transactions.filter({$0.payer == name && $0.currency == currency})
        let myIncoming = transactions.filter({$0.payer != name && $0.currency == currency})
        
        let allNames = TransactionFuncs.getAllNames(transactions)
        let groupedNames = TransactionFuncs.getSyndAndBrokerNames(allNames)
        
        let names = groupedNames.syndNames.contains(name) ? groupedNames.brokerNames : groupedNames.syndNames
        
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
    
    static func getCurrencies(transactions: [Transaction]) -> [String] {
        var currencies = [String]()
        
        for transaction in transactions {
            if !currencies.contains(transaction.currency) {
                currencies.append(transaction.currency)
            }
        }
        currencies.sortInPlace()
        return currencies
    }
}

