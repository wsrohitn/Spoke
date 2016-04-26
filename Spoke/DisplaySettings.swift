//
//  DisplaySettings.swift
//  Spoke
//
//  Created by Rohit Natarajan on 26/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import Foundation

class DisplaySettings {
    static let sharedInstance = DisplaySettings()
    
    var opacity: Float = 0.5
    var spokeFormat = SpokeFormat.Capsule
    
    enum SpokeFormat {
        case Capsule
        case Box
        case Cylinder
    }
}