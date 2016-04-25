//
//  Transaction.swift
//  Spoke
//
//  Created by Rohit Natarajan on 22/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import Foundation

var regSynd: NSRegularExpression?

class Transaction {
    let payer: String
    let payee: String
    let syndicate: String
    let broker: String
    let amount: NSDecimalNumber
    let s2bAmount: NSDecimalNumber
    var currency: String
    let year: Int
    let month: Int
    let day: Int
    
    init(payer: String, payee: String, amount: NSDecimalNumber, currency: String, year: Int, month: Int, day: Int) {
        self.payer = payer
        self.payee = payee
        self.amount = amount
        self.currency = currency
        self.year = year
        self.month = month
        self.day = day
        if regSynd == nil {
            do {
                regSynd = try NSRegularExpression(pattern: "^S[0-9]+$", options: .CaseInsensitive)
            } catch {
                print("error creating regSynd")
            }
        }
        
        var s = ""
        var b = ""
        if Transaction.isSyndicate(payer) {
            s = payer
            b = payee
        } else {
            s = payee
            b = payer
        }
        
        self.syndicate = s
        self.broker = b
        if self.broker == payee {
            s2bAmount = amount
        } else {
            s2bAmount = amount.decimalNumberByMultiplyingBy(-1)
        }
    }
    
    class func isSyndicate(str: String) -> Bool {
        if let regx = regSynd {
            if let _ = regx.firstMatchInString(str, options: [], range: NSMakeRange(0, str.characters.count)) {
                return true
            }
        }
        return false
    }
}
