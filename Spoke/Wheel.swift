//
//  Wheel.swift
//  Spoke
//
//  Created by Rohit Natarajan on 20/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//
//
import Foundation
import UIKit

class Wheel {
    let centerLabel: String
    let currency: String
    let spokes: [NetTransaction]
    let maxAmount: NSDecimalNumber
    
    init(centerLabel: String, spokes: [NetTransaction], currency: String) {
        self.centerLabel = centerLabel
        self.spokes = spokes
        self.currency = currency
        let amounts = spokes.map( {$0.amount.abs() })
        let sortedAmounts = amounts.sort( { $0.compare($1) == .OrderedDescending })        
        maxAmount = sortedAmounts.count > 0 ? sortedAmounts[0] : 0
    }
}