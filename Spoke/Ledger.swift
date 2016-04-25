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
            balances.append( Balance( otherParty: p, amount: 0))
        }
        
        for t in transactions {
            let party = self.isSyndicate ? t.broker : t.syndicate
            let amount = self.isSyndicate ? t.s2bAmount : t.s2bAmount.decimalNumberByMultiplyingBy(-1)
            if let idx = balances.indexOf({ $0.otherParty == party }) {
                balances[idx].amount = balances[idx].amount.decimalNumberByAdding(amount)
            } else {
                let balance = Balance(otherParty: party, amount: amount)
                balances.append(balance)
            }
        }
        
        maxAmount = NSDecimalNumber.zero()
        for s in balances {
            if s.amount.abs() > maxAmount {
                maxAmount = s.amount.abs()
            }
        }
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Ledger(owner: owner, currency: currency, transactions: transactions, balances: balances, maxAmount: maxAmount)
        return copy
    }
    
    struct Balance {
        let otherParty: String
        var amount: NSDecimalNumber
    }
}