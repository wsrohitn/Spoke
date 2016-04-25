//
//  SpokeScene.swift
//  Spoke
//
//  Created by Jonathan Clarke on 25/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import Foundation
import SceneKit

class SpokeScene: SCNScene {
    var ledgers = [Ledger]()
    //var m_node : SCNNode? = nil
    
    func setData(ledgers : [Ledger] )
    {
        self.ledgers = []
        self.ledgers.appendContentsOf( ledgers )
        displayAll()
    }
    
    func displayAll()
    {
        self.rootNode.addChildNode( SpokeScene.createCapNodeWithSide( 10.0, height: 30.0 ) )
    }
    
    private func addAmbientLight() {
        let light = SCNLight()
        light.type = SCNLightTypeAmbient
        light.castsShadow = false
        light.color = UIColor(white: 0.5, alpha: 1.0)
        light.categoryBitMask = 3
        let light_node = SCNNode()
        light_node.light = light
        self.rootNode.addChildNode(light_node)
    }
    
    private class func createMaterialForColour(colour: UIColor) -> SCNMaterial {
        let mat = SCNMaterial()
        mat.diffuse.contents = colour
        mat.specular.contents = UIColor.whiteColor()
        return mat
    }
    
    private class func createCapNodeWithSide(side: Float, height: Float ) -> SCNNode {
        let cgside = CGFloat(side)
        let geom = SCNBox(width: cgside, height: cgside, length: CGFloat(height), chamferRadius: 0)
        geom.firstMaterial = createMaterialForColour( UIColor.yellowColor() )
        let node = SCNNode()
        node.geometry = geom
        node.categoryBitMask = 1
        return node
    }
}