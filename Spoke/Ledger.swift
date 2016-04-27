//
//  Ledger.swift
//  Spoke
//
//  Created by Rohit Natarajan on 20/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//
//
import Foundation
import WsBase
import UIKit

class Ledger: NSObject, NSCopying {
    let owner: String
    let currency: String
    let isSyndicate: Bool
    var transactions = [Transaction]()
    var balances = [Balance]()
    var maxAmount = NSDecimalNumber.zero()
//    var posMaxAmount = NSDecimalNumber.zero()
//    var negMaxAmount = NSDecimalNumber.zero()
    
    init(owner: String, currency: String, transactions: [Transaction] = [], balances: [Balance] = [], maxAmount: NSDecimalNumber = NSDecimalNumber.zero()) {
        self.owner = owner
        self.currency = currency
        self.isSyndicate = Transaction.isSyndicate(owner)
        self.transactions = transactions
        self.balances = balances
        self.maxAmount = maxAmount
    }
    
    func add(t: Transaction) {
        transactions.append(t)
    }
    
    func calcBalances() {
        balances = []
        for p in ( isSyndicate ? GlobalBrokers : GlobalSyndicates ) {
            balances.append( Balance( otherParty: p, amount: 0, posAmount: 0, negAmount: 0))
        }
        
        for t in transactions {
            let party = self.isSyndicate ? t.broker : t.syndicate
            let amount = self.isSyndicate ? t.s2bAmount : t.s2bAmount.decimalNumberByMultiplyingBy(-1)
            if let idx = balances.indexOf({ $0.otherParty == party }) {
                if amount < NSDecimalNumber.zero() {
                    balances[idx].negAmount = balances[idx].negAmount.decimalNumberByAdding(amount)
                } else {
                    //balances[idx].amount = balances[idx].amount.decimalNumberByAdding(amount)
                    balances[idx].posAmount = balances[idx].posAmount.decimalNumberByAdding(amount)
                }
            } else {
                if amount < NSDecimalNumber.zero() {
                    let balance = Balance(otherParty: party, amount: 0, posAmount: 0, negAmount: amount)
                    balances.append(balance)
                } else {
                    let balance = Balance(otherParty: party, amount: 0, posAmount: amount, negAmount: 0)
                    balances.append(balance)
                }
            }
        }
        
        for i in 0 ..< balances.count {
            balances[i].amount = balances[i].posAmount.decimalNumberByAdding(balances[i].negAmount)
        }

        maxAmount = NSDecimalNumber.zero()
//        posMaxAmount = NSDecimalNumber.zero()
//        negMaxAmount = NSDecimalNumber.zero()
        for s in balances {
            if s.amount.abs() > maxAmount {
                maxAmount = s.amount.abs()
            }
//            if s.negAmount.abs() > negMaxAmount {
//                negMaxAmount = s.negAmount.abs()
//            }
//            if s.posAmount.abs() > posMaxAmount {
//                posMaxAmount = s.posAmount.abs()
//            }
        }
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Ledger(owner: owner, currency: currency, transactions: transactions, balances: balances, maxAmount: maxAmount)
        return copy
    }
    
    struct Balance {
        let otherParty: String
        var amount: NSDecimalNumber
        var posAmount: NSDecimalNumber
        var negAmount: NSDecimalNumber
    }
}