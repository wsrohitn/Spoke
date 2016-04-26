//
//  DisplaySettingsVC.swift
//  Spoke
//
//  Created by Rohit Natarajan on 26/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

class DisplaySettingsVC: UIViewController {
    
    static func LoadVC(sb: UIStoryboard, nc: UINavigationController, title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("DisplaySettingsVC") as? DisplaySettingsVC {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title)
        }
    }
    
    private func setInitialState(title : String)
    {
        self.title = title
    }

    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var spokeFormat: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opacitySlider.value = DisplaySettings.sharedInstance.opacity
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func opacitySliderValue(sender: UISlider) {
        DisplaySettings.sharedInstance.opacity = opacitySlider.value
        print(DisplaySettings.sharedInstance.opacity)
    }
}
