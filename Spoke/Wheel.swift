//
//  Wheel.swift
//  Spoke
//
//  Created by Rohit Natarajan on 20/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//
//
import Foundation
import WsBase
import UIKit

class Wheel {
    let centerLabel: String
    let currency: String
    let isSyndicate: Bool
    var transactions = [Transaction]()
    var spokes = [Spoke]()
    var maxAmount = NSDecimalNumber.zero()
    
    init(centerLabel: String, currency: String) {
        self.centerLabel = centerLabel
        self.currency = currency
        self.isSyndicate = Transaction.isSyndicate(centerLabel)
    }
    
    func add(t: Transaction) {
        transactions.append(t)
    }
    
    func calcSpokes() {
        spokes = []
        for t in transactions {
            let party = self.isSyndicate ? t.broker : t.syndicate
            if let idx = spokes.indexOf({ $0.otherParty == party }) {
                spokes[idx].amount = spokes[idx].amount.decimalNumberByAdding(t.s2bAmount)
            } else {
                let spoke = Spoke(otherParty: party, amount: t.s2bAmount)
                spokes.append(spoke)
            }
        }
        
        maxAmount = NSDecimalNumber.zero()
        for s in spokes {
            if s.amount.abs() > maxAmount {
                maxAmount = s.amount.abs()
            }
        }
    }
    
    struct Spoke {
        let otherParty: String
        var amount: NSDecimalNumber
    }
}