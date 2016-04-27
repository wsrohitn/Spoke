//
//  MenuTVCTableViewController.swift
//  Spoke
//
//  Created by Rohit Natarajan on 21/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit
import WsBase
import WsCouchBasic

var GlobalSyndicates = [String]()
var GlobalBrokers = [String]()

class MenuTVC: UITableViewController {
    
    var login = Login(forUrl: "")
    let dataSet = TransactionSet()
    var brokers = [String]()
    var syndicates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "SYND", style: .Plain, target: self, action: #selector(MenuTVC.clickSynd)),
            UIBarButtonItem(title: "BRK", style: .Plain, target: self, action: #selector(MenuTVC.clickBRK)),
            UIBarButtonItem(title: "Month", style: .Plain, target: self, action: #selector(MenuTVC.clickMonth)),
            UIBarButtonItem(title: "Year", style: .Plain, target: self, action: #selector(MenuTVC.clickYear)),
            UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(MenuTVC.clickSettings))
        ]
        
        login = Login( forUrl: CBSettings.sharedInstance.url )
        if login.isValid {
            afterLogin()
        } else {
            self.view.userInteractionEnabled = false
            doLogin()
        }
    }
    
    func clickSettings() {
        DisplaySettingsVC.LoadVC(self.storyboard!, nc: self.navigationController! , title: "Display Settings")
    }
    
    func clickMonth() {
        let ds = dataSet.buildSubSet( {  $0.year == 2016 && $0.month == 4 } )
        let wheels = ds.getBrokerDataSet()
        WheelCVC.LoadVC(self.storyboard!, nc: self.navigationController!, wheels: wheels, title: "Brokers 4/2016")
    }
    
    func clickYear() {
        let ds = dataSet.buildSubSet( {  $0.year == 2016 } )
        let wheels = ds.getBrokerDataSet()
        WheelCVC.LoadVC(self.storyboard!, nc: self.navigationController!, wheels: wheels, title: "Brokers 2016")
    }
    
    
    func clickBRK() {
        let ledgers =  dataSet.getBrokerDataSet()
        GridVC.LoadVC(self.storyboard!, nc: self.navigationController!, ledgers: ledgers.filter({$0.currency == "GBP"}), title: "Brokers")
        //WheelCVC.LoadVC(self.storyboard!, nc: self.navigationController!, wheels: ledgers, title: "Brokers")
    }
    
    func clickSynd() {
        let wheels = dataSet.getSyndicateDataSet()
        WheelCVC.LoadVC(self.storyboard!, nc: self.navigationController!, wheels: wheels, title: "Syndicates")
    }
    
    func afterLogin() {
        CBSettings.sharedInstance.setCredentials( login.userName, password : login.password )
        SyncManager.sharedInstance.startContinuousReplication(withSettings: CBSettings.sharedInstance)
        if let database = SyncManager.sharedInstance.database {
            print( "afterLogin", login.userName, "has", database.documentCount, "documents" )
        }
        dataSet.loadData()
        brokers = Array(Set(dataSet.transactions.map( {$0.broker})))
        syndicates = Array(Set(dataSet.transactions.map( {$0.syndicate})))

        GlobalBrokers = brokers
        GlobalSyndicates = syndicates
        
        tableView.reloadData()
    }
    
    func doLogin() {
        LoginAlert.show(forLogin: login, withParentController: self, thenCallback: { (isOK: Bool) in
            if isOK {
                self.view.userInteractionEnabled = true
                self.afterLogin()
            }
            else {
                self.view.userInteractionEnabled = false
                self.doLogin()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? syndicates.count : brokers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath)
        cell.textLabel?.text = indexPath.section == 0 ? syndicates[indexPath.row] : brokers[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let name = indexPath.section == 0 ? syndicates[indexPath.row] : brokers[indexPath.row]
        
        if Transaction.isSyndicate(name) {
            let wheels = dataSet.getSyndicateDataSet()
            if let ledger = wheels.filter( { $0.owner == name && $0.currency == "GBP" } ).first {
                WheelViewController.LoadVC(self.storyboard!, nc: self.navigationController!, ledger: ledger, title: name)
            }
        } else {
            let wheels = dataSet.getBrokerDataSet()
            let ledgers = wheels.filter( { $0.owner == name } )
            ThreeDeeVC.LoadVC(self.storyboard!, nc: self.navigationController!, ledgers : ledgers, title : name )
            // WheelViewController.LoadVC(self.storyboard!, nc: self.navigationController!, ledger: ledger, title: name)
            
        }
    }
}
