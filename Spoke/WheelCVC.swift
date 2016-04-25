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
    var ledgers: [Ledger]?
    var names = [String]()
    var currencies = [String]()
    var ratesDict = StringKeyDict()
    var scaleToggled: Bool = false
    var currencyToggled: Bool = false
    
    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, wheels: [Ledger], title: String) {
        if let vc = sb.instantiateViewControllerWithIdentifier("WheelCVC") as? WheelCVC {
            nc.pushViewController(vc, animated: true)
            vc.setInitialState(title, wheels: wheels)
        }
    }
    
    func setInitialState(title: String, wheels: [Ledger]) {
        self.title = title
        self.ledgers = wheels
        getNames()
        getCurrencies()
        setupExchangeRates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Scale", style: .Plain, target: self, action: #selector(WheelCVC.toggleScale)),
            UIBarButtonItem(title: "Currency", style: .Plain, target: self, action: #selector(WheelCVC.toggleCurrency))
        ]
    }
    
    private func setupExchangeRates() {
        ratesDict["CAD"] = 0.54
        ratesDict["EUR"] = 0.78
        ratesDict["GBP"] = 1
        ratesDict["SEK"] = 0.08
        ratesDict["USD"] = 0.69
    }
    
    func toggleScale() {
        scaleToggled = !scaleToggled
        print("scale toggled", scaleToggled)
        collectionView!.reloadData()
    }
    
    func getGlobalMaxAmount() -> NSDecimalNumber {
        var max = NSDecimalNumber.zero()
        for l in ledgers! {
            if l.maxAmount.abs() > max {
                max = l.maxAmount.abs()
            }
        }
        return max
    }
    
    func toggleCurrency() {
        currencyToggled = !currencyToggled
        print("currency toggled", currencyToggled)
        collectionView!.reloadData()
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
        for name in ledgers!.map( {$0.owner }) {
            if !names.contains(name) {
                names.append(name)
            }
        }
        names.sortInPlace()
    }
    
    func getCurrencies() {
        for currency in ledgers!.map( {$0.currency}) {
            if !currencies.contains(currency) {
                currencies.append(currency)
            }
        }
        currencies.sortInPlace()
    }
    
    func getTransformedLedger(ledger: Ledger) -> Ledger {
        if scaleToggled || currencyToggled {
            let newLedger = ledger.copy() as! Ledger
            if currencyToggled {
                for i in 0 ..< ledger.balances.count {
                    let amt = ledger.balances[i].amount
                    newLedger.balances[i].amount = amt.decimalNumberByMultiplyingBy(NSDecimalNumber(double:ratesDict.getDouble(ledger.currency)))
                }
            }
            if scaleToggled {
                newLedger.maxAmount = getGlobalMaxAmount()
            }
            return newLedger
        } else {
            return ledger
        }
    }
    
    func getWheel(indexPath: NSIndexPath) -> Ledger {
        let name = names[indexPath.section]
        let currency = currencies[indexPath.row]
        
        if let idx = ledgers!.indexOf( {$0.owner == name && $0.currency == currency}) {
            return getTransformedLedger( ledgers![idx] )
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