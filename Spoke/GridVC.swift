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
    
    private var ledgers = [Ledger]()
    private var names = [String]()
    private var currencies = [String]()
    private var maxAmount = NSDecimalNumber.zero()
    private var posColors = [String: UIColor]()
    private var negColors = [String: UIColor]()
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, ledgers : [Ledger], title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("GridVC") as? GridVC {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, ledgers: ledgers)
        }
    }
    
    private func setInitialState( title : String, ledgers : [Ledger] )
    {
        self.title = title
        self.ledgers = ledgers
        self.maxAmount = ledgers.map({$0.maxAmount}).reduce(NSDecimalNumber.zero(), combine: { $0 > $1 ? $0 : $1})
        getNames()
        getCurrencies()
        setupColors()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayAllCurrencies()
        print(currencies)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayAllCurrencies() {
        let scene = makeScene()
        
        var posHeights = [Float]()
        var negHeights = [Float]()
        
        for _ in ledgers[0].balances {
            posHeights.append(0.0)
            negHeights.append(0.0)
        }
        
        var i: Float = 0.0
        for name in names {
            var tmpPosHeights = posHeights
            var tmpNegHeights = negHeights
            
            for currency in currencies {
                let ledger = getLedgerFor(name, currency: currency)
                let cylinders = makeCylindersFromLedger(ledger, origin: SCNVector3(x: 0, y: 0, z: 0 + i), posHeights: &tmpPosHeights, negHeights: &tmpNegHeights)
                for cylinder in cylinders {
                    scene.rootNode.addChildNode(cylinder)
                }
            }
            
            i += 0.3
        }
    }
    
    private func getLedgerFor(name: String, currency: String) -> Ledger {
        return ledgers.filter( {$0.owner == name && $0.currency == currency}).first!
    }
    
    func makeScene() -> SCNScene {
        let sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        if let img = UIImage(named: DisplaySettings.sharedInstance.bgImgName){
            print("got image")
            scene.background.contents = img
        } else {
            print("no image :(")
        }
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0.1 * Float(ledgers[0].balances.count), y: 0.0, z: 0.15 * Float(ledgers.count)) //SCNVector3(x: -3.0, y: 3.0, z: 3.0)
        
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
//        sphereNode.position = SCNVector3(x: 0.1 * Float(ledgers[0].balances.count), y: 0.0, z: 0.15 * Float(ledgers.count))
//        
//        let constraint = SCNLookAtConstraint(target: sphereNode)
//        constraint.gimbalLockEnabled = true
//        cameraNode.constraints = [constraint]
        
        return scene
    }
    
    func makeCylindersFromLedger(ledger: Ledger, origin: SCNVector3, inout posHeights: [Float], inout negHeights: [Float]) -> [SCNNode] {
        var cylinders = [SCNNode]()
        
        var i: Float = 0.2
        for idx in 0 ..< ledger.balances.count {
            let balance = ledger.balances[idx]
            
            let posHeight = balance.posAmount.abs().decimalNumberByDividingBy(maxAmount)
            let negHeight = balance.negAmount.abs().decimalNumberByDividingBy(maxAmount)
            
            let posCylinderNode = makeCylinder(SCNVector3(x: origin.x + i, y: origin.y + posHeights[idx], z: origin.z), height: posHeight.floatValue, positive: true, currency: ledger.currency)
            posHeights[idx] += posHeight.floatValue
            cylinders.append(posCylinderNode)
            let negCylinderNode = makeCylinder(SCNVector3(x: origin.x + i, y: origin.y + negHeights[idx], z: origin.z), height: negHeight.floatValue, positive: false, currency: ledger.currency)
            negHeights[idx] -= negHeight.floatValue
            cylinders.append(negCylinderNode)
            
            i += 0.1
        }
        
        return cylinders
    }
    
    func makeCylinder(origin: SCNVector3, height: Float, positive: Bool, currency: String = "") -> SCNNode {
        let cylinderGeom = SCNCylinder(radius: 0.025, height: CGFloat(height))
        let cylinderNode = SCNNode(geometry: cylinderGeom)
        
        let positiveMaterial = SCNMaterial()
        positiveMaterial.diffuse.contents = posColors[currency] //DisplaySettings.sharedInstance.getPosSpokeColor() //
        let negativeMaterial = SCNMaterial()
        negativeMaterial.diffuse.contents = negColors[currency]  //DisplaySettings.sharedInstance.getNegSpokeColor()
        
        if positive {
            cylinderNode.pivot = SCNMatrix4MakeTranslation(0.0, -1.0 * height/2.0, 0.0)
            cylinderNode.geometry!.materials = [positiveMaterial]
        } else {
            cylinderNode.pivot = SCNMatrix4MakeTranslation(0.0, height/2.0, 0.0)
            cylinderNode.geometry!.materials = [negativeMaterial]
        }
        
        cylinderNode.position = origin
        return cylinderNode
    }
    
    private func setupColors() {
        posColors["CAD"] = DisplaySettings.sharedInstance.getColorFromHex("293757")
        posColors["EUR"] = DisplaySettings.sharedInstance.getColorFromHex("568D4B")
        posColors["GBP"] = DisplaySettings.sharedInstance.getColorFromHex("D5BB56")
        posColors["SEK"] = DisplaySettings.sharedInstance.getColorFromHex("D26A1B")
        posColors["USD"] = DisplaySettings.sharedInstance.getColorFromHex("A41D1A")
        
        negColors["CAD"] = DisplaySettings.sharedInstance.getColorFromHex("C1395E")
        negColors["EUR"] = DisplaySettings.sharedInstance.getColorFromHex("AEC17B")
        negColors["GBP"] = DisplaySettings.sharedInstance.getColorFromHex("F0CA50")
        negColors["SEK"] = DisplaySettings.sharedInstance.getColorFromHex("E07B42")
        negColors["USD"] = DisplaySettings.sharedInstance.getColorFromHex("89A7C2")
    }
    
    func getNames() {
        for name in ledgers.map( {$0.owner }) {
            if !names.contains(name) {
                names.append(name)
            }
        }
        names.sortInPlace()
    }
    
    func getCurrencies() {
        for currency in ledgers.map( {$0.currency}) {
            if !currencies.contains(currency) {
                currencies.append(currency)
            }
        }
        currencies.sortInPlace()
    }
}