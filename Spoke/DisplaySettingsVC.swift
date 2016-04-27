//
//  DisplaySettingsVC.swift
//  Spoke
//
//  Created by Rohit Natarajan on 26/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

class DisplaySettingsVC: UIViewController, UITextFieldDelegate {
    
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
    
    @IBOutlet weak var sliderValue: UILabel!
    
    @IBOutlet weak var diskBG: UITextField!
    @IBOutlet weak var negativeSpokeColor: UITextField!
    @IBOutlet weak var positiveSpokeColor: UITextField!
    
    @IBOutlet weak var diskView: UIView!
    @IBOutlet weak var posSpokeView: UIView!
    @IBOutlet weak var negSpokeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opacitySlider.value = DisplaySettings.sharedInstance.opacity
        sliderValue.text! = opacitySlider.value.description
        
        if DisplaySettings.sharedInstance.spokeFormat == SpokeFormat.Box {
            spokeFormat.selectedSegmentIndex = 0
        } else if DisplaySettings.sharedInstance.spokeFormat == SpokeFormat.Capsule {
            spokeFormat.selectedSegmentIndex = 1
        } else {
            spokeFormat.selectedSegmentIndex = 2
        }
        
        diskBG.delegate = self
        positiveSpokeColor.delegate = self
        negativeSpokeColor.delegate = self
        
        diskBG.text = DisplaySettings.sharedInstance.diskColor
        positiveSpokeColor.text = DisplaySettings.sharedInstance.positiveSpokeColor
        negativeSpokeColor.text = DisplaySettings.sharedInstance.negativeSpokeColor
        
        diskView.backgroundColor = DisplaySettings.sharedInstance.getDiskColor()
        posSpokeView.backgroundColor = DisplaySettings.sharedInstance.getPosSpokeColor()
        negSpokeView.backgroundColor = DisplaySettings.sharedInstance.getNegSpokeColor()
        
        print(UIColor.lightGrayColor().makeCSV())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func spokeFormatChanged(sender: UISegmentedControl) {
        if spokeFormat.selectedSegmentIndex == 0 {
            print("First Segment Selected")
            DisplaySettings.sharedInstance.spokeFormat = SpokeFormat.Box
        }
        else if spokeFormat.selectedSegmentIndex == 1 {
            print( "Second Segment Selected")
            DisplaySettings.sharedInstance.spokeFormat = SpokeFormat.Capsule
        }
        else if spokeFormat.selectedSegmentIndex == 2 {
            print("Third Segment Selected")
            DisplaySettings.sharedInstance.spokeFormat = SpokeFormat.Cylinder
        }
    }
    
    @IBAction func diskEditEnded(sender: UITextField) {
        DisplaySettings.sharedInstance.diskColor = diskBG.text!
        print(DisplaySettings.sharedInstance.diskColor)
        diskView.backgroundColor = DisplaySettings.sharedInstance.getDiskColor()
    }
    
    @IBAction func posSpokeEditEnded(sender: UITextField) {
        DisplaySettings.sharedInstance.positiveSpokeColor = positiveSpokeColor.text!
        print(DisplaySettings.sharedInstance.positiveSpokeColor)
        posSpokeView.backgroundColor = DisplaySettings.sharedInstance.getPosSpokeColor()
    }
    
    @IBAction func negSpokeEditEnd(sender: UITextField) {
        DisplaySettings.sharedInstance.negativeSpokeColor = negativeSpokeColor.text!
        print(DisplaySettings.sharedInstance.negativeSpokeColor)
        negSpokeView.backgroundColor = DisplaySettings.sharedInstance.getNegSpokeColor()
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        diskBG.resignFirstResponder()
        positiveSpokeColor.resignFirstResponder()
        negativeSpokeColor.resignFirstResponder()
        return true;
    }

    @IBAction func opacitySliderValue(sender: UISlider) {
        DisplaySettings.sharedInstance.opacity = opacitySlider.value
        sliderValue.text = opacitySlider.value.description
    }
}
