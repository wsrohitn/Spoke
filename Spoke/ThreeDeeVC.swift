//
//  ThreeDeeVC.swift
//  Spoke
//
//  Created by Jonathan Clarke on 25/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit
import WsBase
import SceneKit

class ThreeDeeVC: UIViewController {
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, ledgers : [Ledger], title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("ThreeDeeVC") as? ThreeDeeVC {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, ledgers: ledgers)
        }
    }
    
    private weak var m_scene: SpokeScene!
    private var ledgers = [Ledger]()
    
    private func setInitialState( title : String, ledgers : [Ledger] )
    {
        self.title = title
        self.ledgers = ledgers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAllWheels()
    }
    
    func makeCylinder(origin: SCNVector3) -> SCNNode {
        let cylinderGeom = SCNCylinder(radius: 1.0, height: 0.01)
        
        let cylinderNode = SCNNode(geometry: cylinderGeom)
        cylinderNode.opacity = CGFloat(DisplaySettings.sharedInstance.opacity)
        cylinderNode.position = origin
        
        let diskMaterial = SCNMaterial()
        diskMaterial.diffuse.contents = DisplaySettings.sharedInstance.getDiskColor()
        cylinderNode.geometry!.materials = [diskMaterial]
        
        return cylinderNode
    }
    
    func makeCapsules(origin: SCNVector3, balances: [Ledger.Balance]) -> [SCNNode] {
        let num = balances.count
        let theta = Float(2 * M_PI / Double(num))
        let max = balances.map({$0.amount.abs()}).reduce(NSDecimalNumber.zero(), combine: { $0 > $1 ? $0 : $1})
        
        let positiveMaterial = SCNMaterial()
        positiveMaterial.diffuse.contents = DisplaySettings.sharedInstance.getPosSpokeColor() //UIColor.greenColor()
        
        let negativeMaterial = SCNMaterial()
        negativeMaterial.diffuse.contents = DisplaySettings.sharedInstance.getNegSpokeColor() //UIColor.redColor()
        
        var capsules = [SCNNode]()
        for i in 0 ..< num {
            let height = balances[i].amount.abs().decimalNumberByDividingBy(max)
            var node = SCNNode()
            if DisplaySettings.sharedInstance.spokeFormat == SpokeFormat.Box {
                let boxGeom = SCNBox(width: 0.025, height: CGFloat(height.floatValue), length: 0.025, chamferRadius: 0.0)
                node = SCNNode(geometry: boxGeom)
            }
            else if DisplaySettings.sharedInstance.spokeFormat == SpokeFormat.Capsule {
                let capsuleGeom = SCNCapsule(capRadius: 0.025, height: CGFloat(height.floatValue))
                node = SCNNode(geometry: capsuleGeom)
            }
            else {
                let cylinderGeom = SCNCylinder(radius: 0.025, height: CGFloat(height.floatValue))
                node = SCNNode(geometry: cylinderGeom)
            }
            
            node.position = origin
            node.pivot = SCNMatrix4MakeTranslation(0.0, height.floatValue/2.0, 0.0)
            node.eulerAngles = SCNVector3(x: Float(M_PI_2), y: Float(i) * theta, z: 0.0)
            
            node.geometry!.materials = balances[i].amount < NSDecimalNumber.zero() ? [negativeMaterial] : [positiveMaterial]
            capsules.append(node)
        }
        
        return capsules
    }
    
    func getWheelFromLedger(ledger: Ledger, origin: SCNVector3) -> (cylinder: SCNNode, capsules: [SCNNode]) {
        let cylinder = makeCylinder(origin)
        let capsules = makeCapsules(origin, balances: ledger.balances)
        return (cylinder, capsules)
    }
    
    func makeAllWheels() {
        let scene = makeScene()
        
        var i = Float(0.0)
        for ledger in ledgers {
            let wheel = getWheelFromLedger(ledger, origin: SCNVector3(x: 0.0, y: 0.0 + i, z: 0.0))
            scene.rootNode.addChildNode(wheel.cylinder)
            for capsule in wheel.capsules {
                scene.rootNode.addChildNode(capsule)
            }
            i += 0.6
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        let geom = SCNSphere(radius: 0.0)
        let sphereNode = SCNNode(geometry: geom)
        sphereNode.position = SCNVector3(x: 0.0, y: 1.2, z: 0.0)
        
        let constraint = SCNLookAtConstraint(target: sphereNode)
        constraint.gimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        
        return scene
    }
    
    private func showData(ledgers: [Ledger] ) {
        if m_scene == nil {
            let scene = SpokeScene()
            scene.setData(ledgers)
            m_scene = scene
//            m_chart_scene_view.scene = scene
//            m_mode_selected.selectedSegmentIndex = 0
        }
        else {
            m_scene!.setData(ledgers)
        }
    }

}
