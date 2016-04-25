//
//  ThreeDeeVC.swift
//  Spoke
//
//  Created by Jonathan Clarke on 25/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

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
        showData( ledgers )
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
