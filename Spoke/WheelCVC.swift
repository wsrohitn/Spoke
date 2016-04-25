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
    var wheels: [Ledger]?
    var names = [String]()
    var currencies = [String]()
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, wheels: [Ledger], title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("WheelCVC") as? WheelCVC {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, wheels: wheels)
        }
    }
    
    func setInitialState(title: String, wheels: [Ledger]) {
        self.title = title
        self.wheels = wheels
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
        return names.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let ledger = getWheel(indexPath)
        WheelView.makeInView(cell, ledger: ledger)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader", forIndexPath: indexPath)
        header.backgroundColor = UIBranding.sharedInstance.branding.sectionHeaderBackgroundColor
        
        let str = names[indexPath.section]
        for v in header.subviews {
            if let lbl = v as? UILabel {
                lbl.text = str
                lbl.textColor = UIBranding.sharedInstance.branding.titleColor
            }
        }
        
        return header
    }
    
    func getNames() {
        for name in wheels!.map( {$0.owner }) {
            if !names.contains(name) {
                names.append(name)
            }
        }
        names.sortInPlace()
    }
    
    func getCurrencies() {
        for currency in wheels!.map( {$0.currency}) {
            if !currencies.contains(currency) {
                currencies.append(currency)
            }
        }
        currencies.sortInPlace()
    }
    
    func getWheel(indexPath: NSIndexPath) -> Ledger {
        let name = names[indexPath.section]
        let currency = currencies[indexPath.row]
        
        if let idx = wheels!.indexOf( {$0.owner == name && $0.currency == currency}) {
            return wheels![idx]
        } else {
            print( "creating ledger for \(name) \(currency)")
            return Ledger(owner: name, currency: currency )
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let ledger = getWheel(indexPath)
        
        WheelViewController.LoadVC(self.storyboard!, nc: self.navigationController!, ledger: ledger, title: "\(ledger.owner), \(ledger.currency)")
    }
}
