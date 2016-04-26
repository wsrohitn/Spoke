//
//  ThreeDeeVC.swift
//  Spoke
//
//  Created by Jonathan Clarke on 25/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit
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
        sceneKitTut()
        //showData( ledgers )
    }
    
    func sceneKitTut() {
        let sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: -3.0, y: 3.0, z: 3.0)
        //cameraNode.position = SCNVector3(x: 0.0, y: 3.0, z: 0.0)
        
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        
        let ambientLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        cameraNode.light = ambientLight
        
//        let tubeGeom = SCNTube(innerRadius: 1.0, outerRadius: 1.0, height: 0.01)
//        let tubeNode = SCNNode(geometry: tubeGeom)
        
        let cylinders = makeCylinders(5, origin: SCNVector3(x: 0.0, y: 0.0, z: 0.0))
        
        for cylinder in cylinders {
            scene.rootNode.addChildNode(cylinder)
            let capsules = makeCapsules(Int(arc4random_uniform(10)), origin: cylinder.position)
            for capsule in capsules {
                scene.rootNode.addChildNode(capsule)
            }
        }
        
        let constraint = SCNLookAtConstraint(target: cylinders[2])
        constraint.gimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)
        sceneView.allowsCameraControl = true
    }
    
    func makeCapsules(num: Int, origin: SCNVector3) -> [SCNNode] {
        let capsuleGeom = SCNCapsule(capRadius: 0.025, height: 1.0)
        let theta = Float(2 * M_PI / Double(num))
        
        let greenMaterial = SCNMaterial()
        greenMaterial.diffuse.contents = UIColor.greenColor()
        
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.redColor()
        
        var capsules = [SCNNode]()
        for i in 0 ..< num {
            let capsuleNode = SCNNode(geometry: capsuleGeom)
            capsuleNode.position = origin
            capsuleNode.pivot = SCNMatrix4MakeTranslation(0.0, 0.5, 0.0)
            capsuleNode.eulerAngles = SCNVector3(x: Float(M_PI_2), y: Float(i) * theta, z: 0.0)
            capsuleNode.geometry!.materials = [redMaterial]
            capsules.append(capsuleNode)
        }
        
        return capsules
    }
    
    func makeCylinders(num: Int, origin: SCNVector3) -> [SCNNode] {
        let cylinderGeom = SCNCylinder(radius: 1.0, height: 0.01)
        let spacing = Float(0.6)
        let x = origin.x
        let y = origin.y
        let z = origin.z
        
        let grayMaterial = SCNMaterial()
        grayMaterial.diffuse.contents = UIColor.lightGrayColor()
        
        var cylinders = [SCNNode]()
        for i in 0 ..< num {
            let cylinderNode = SCNNode(geometry: cylinderGeom)
            cylinderNode.opacity = 0.85
            cylinderNode.position = SCNVector3(x: x, y: y + Float(i) * spacing, z: z)
            cylinderNode.geometry!.materials = [grayMaterial]
            cylinders.append(cylinderNode)
        }
        
        return cylinders
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
