//
//  WheelCVC.swift
//  Spoke
//
//  Created by Rohit Natarajan on 22/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit
import WsBase

private let reuseIdentifier = "WheelCVCell"

class WheelCVC: UICollectionViewController {
    var bkrDicts: StringKeyDict?
    var brokerNames = [String]()
    var currencies = [String]()
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, bkrDicts: StringKeyDict, title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("WheelCVC") as? WheelCVC {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, bkrDicts: bkrDicts)
        }
    }
    
    func setInitialState(title: String, bkrDicts: StringKeyDict) {
        self.title = title
        self.bkrDicts = bkrDicts
        getNames()
        getCurrencies()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return bkrDicts!.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        let name = brokerNames[indexPath.section]
        let bkrDict = bkrDicts![name] as! StringKeyDict
        
        let netTransactions = bkrDict[currencies[indexPath.row]] as! [String: NSDecimalNumber]
        let wheel = Wheel(centerLabel: "DEF", spokes: netTransactions)
        WheelView.makeInView(cell, wheel: wheel)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader", forIndexPath: indexPath)
        header.backgroundColor = UIBranding.sharedInstance.branding.sectionHeaderBackgroundColor
        
        let str = brokerNames[indexPath.section]
        for v in header.subviews {
            if let lbl = v as? UILabel {
                lbl.text = str
                lbl.textColor = UIBranding.sharedInstance.branding.titleColor
            }
        }
        
        return header
    }
    
    func getNames() {
        if let dict = bkrDicts {
            let keys = dict.keys
            for key in keys {
                brokerNames.append(key)
            }
        }
        brokerNames.sortInPlace()
    }
    
    func getCurrencies() {
        let bkrDict = bkrDicts![ brokerNames[0]] as! StringKeyDict
        
        let keys = bkrDict.keys
        for key in keys {
            currencies.append(key)
        }
        currencies.sortInPlace()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let name = brokerNames[indexPath.section]
        let bkrDict = bkrDicts![name] as! StringKeyDict
        let currency = currencies[indexPath.row]
        let netTransactions = bkrDict[currency] as! [String: NSDecimalNumber]

        WheelViewController.LoadVC(self.storyboard!, nc: self.navigationController!, netTransactions: netTransactions, title: "\(name), \(currency)")
    }
}
