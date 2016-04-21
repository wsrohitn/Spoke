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
    let spokes: [String: NSDecimalNumber]
    let maxAmount: NSDecimalNumber
    
    init(centerLabel: String, spokes: [String: NSDecimalNumber]) {
        self.centerLabel = centerLabel
        self.spokes = spokes
        
        let amounts = spokes.values.map( { $0.compare(NSDecimalNumber.zero()) == .OrderedAscending ? NSDecimalNumber.zero().decimalNumberBySubtracting($0) : $0 })
        let sortedAmounts = amounts.sort( { $0.compare($1) == .OrderedDescending })        
        maxAmount = sortedAmounts.count > 0 ? sortedAmounts[0] : 0
    }
}