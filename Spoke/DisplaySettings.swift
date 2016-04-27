//
//  DisplaySettings.swift
//  Spoke
//
//  Created by Rohit Natarajan on 26/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import Foundation
import UIKit

enum SpokeFormat {
    case Capsule
    case Box
    case Cylinder
}

class DisplaySettings {
    static let sharedInstance = DisplaySettings()
    
    var opacity: Float = 0.5
    var spokeFormat = SpokeFormat.Box
    
    var diskColor: String = "565656"
    var positiveSpokeColor: String = "FF0000"
    var negativeSpokeColor: String = "00FF00"
}