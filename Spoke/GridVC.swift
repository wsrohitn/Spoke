//
//  GridVC.swift
//  Spoke
//
//  Created by Rohit Natarajan on 27/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit
import WsBase
import SceneKit

class GridVC: UIViewController {
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, ledgers : [Ledger], title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("GridVC") as? GridVC {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, ledgers: ledgers)
        }
    }
    
    private var ledgers = [Ledger]()
    
    private func setInitialState( title : String, ledgers : [Ledger] )
    {
        self.title = title
        self.ledgers = ledgers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayGrid()
        print("Hello")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayGrid() {
        let scene = makeScene()
        
        let cylinders = makeCylindersFromLedger(ledgers[0], origin: SCNVector3(x: 0.0, y: 0.0, z: 0.0))
        
        for cylinder in cylinders {
            scene.rootNode.addChildNode(cylinder)
        }
    }
    
    func makeScene() -> SCNScene {
        let sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        let scene = SCNScene()
        sceneView.scene = scene
        
//        if let img = UIImage(named: DisplaySettings.sharedInstance.bgImgName){
//            print("got image")
//            scene.background.contents = img
//        } else {
//            print("no image :(")
//        }
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: -3.0, y: 3.0, z: 3.0)
        
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        
        let ambientLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        cameraNode.light = ambientLight
        
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)
        sceneView.allowsCameraControl = true
        
//        let geom = SCNSphere(radius: 0.0)
//        let sphereNode = SCNNode(geometry: geom)
//        sphereNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        
        let constraint = SCNLookAtConstraint(target: scene.rootNode)
        constraint.gimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        
        return scene
    }
    
    func makeCylindersFromLedger(ledger: Ledger, origin: SCNVector3) -> [SCNNode] {
        print(ledger.owner)
        print(ledger.currency)
        var cylinders = [SCNNode]()
        let max = ledger.maxAmount
        
        let positiveMaterial = SCNMaterial()
        positiveMaterial.diffuse.contents = DisplaySettings.sharedInstance.getPosSpokeColor() //UIColor.greenColor()
        
        let negativeMaterial = SCNMaterial()
        negativeMaterial.diffuse.contents = DisplaySettings.sharedInstance.getNegSpokeColor()
        
        var i: Float = 0.1
        for balance in ledger.balances {
            let height = balance.amount.abs().decimalNumberByDividingBy(max)
            let cylinderGeom = SCNCylinder(radius: 0.025, height: CGFloat(height))
            let cylinderNode = SCNNode(geometry: cylinderGeom)
            
            if balance.amount < 0 {
                cylinderNode.pivot = SCNMatrix4MakeTranslation(0.0, height.floatValue/2.0, 0.0)
            } else {
                cylinderNode.pivot = SCNMatrix4MakeTranslation(0.0, -1.0 * height.floatValue/2.0, 0.0)
            }
            cylinderNode.position = SCNVector3(x: origin.x + i, y: origin.y, z: origin.z)
            
            cylinderNode.geometry!.materials = balance.amount < NSDecimalNumber.zero() ? [negativeMaterial] : [positiveMaterial]
            cylinders.append(cylinderNode)            
            i += 0.1
        }
        
        return cylinders
    }

}
