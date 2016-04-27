//
//  DisplaySettings.swift
//  Spoke
//
//  Created by Rohit Natarajan on 26/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import Foundation
import UIKit
import WsBase

enum SpokeFormat {
    case Capsule
    case Box
    case Cylinder
}

class DisplaySettings {
    static let sharedInstance = DisplaySettings()
    
    private let imgNames: [String] = ["blue_graph_paper.jpg", "graph-paper.jpg", "gradient-black-to-white.jpg", "Lloyds_building_London.jpg", "space.jpg"]
    
    var opacity: Float = 0.5
    var spokeFormat = SpokeFormat.Box
    
    var diskColor: String = "565656"
    var positiveSpokeColor: String = "FF0000"
    var negativeSpokeColor: String = "00FF00"
    
    //var bgImgName: String = imgNames[0]
    var bgImgIdx = 4
    var bgImgName: String {
        return imgNames[bgImgIdx]
    }
    
    func getDiskColor() -> UIColor {
        return getColorFromHex(diskColor)
    }
    
    func getPosSpokeColor() -> UIColor {
        return getColorFromHex(positiveSpokeColor)
    }
    
    func getNegSpokeColor() -> UIColor {
        return getColorFromHex(negativeSpokeColor)
    }
    
    private func getColorFromHex(hex: String) -> UIColor {
        
        if hex.length() != 6 {
            return UIColor.lightGrayColor()
        }
        
        let rString = hex.substringToIndex(hex.startIndex.advancedBy(2))
        let gString = hex.substringWithRange( Range(start: hex.startIndex.advancedBy(2), end: hex.startIndex.advancedBy(4) ))
        let bString = hex.substringFromIndex(hex.startIndex.advancedBy(4))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor.makeColour(Int(r), Int(g), Int(b))
    }
}