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

class MenuTVC: UITableViewController {
    
    var testData: TransactionData?
    var login = Login(forUrl: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SYND", style: .Plain, target: self, action: #selector(MenuTVC.clickSynd))
        
        login = Login( forUrl: CBSettings.sharedInstance.url )
        if login.isValid {
            afterLogin()
        } else {
            self.view.userInteractionEnabled = false
            doLogin()
        }
    }
    
    func clickBKR() {
        let wheels = testData!.getBrokerDataSet()
        WheelCVC.LoadVC(self.storyboard!, nc: self.navigationController!, wheels: wheels, title: "Brokers")
    }
    
    func clickSynd() {
        let wheels = testData!.getSyndDataSet()
        WheelCVC.LoadVC(self.storyboard!, nc: self.navigationController!, wheels: wheels, title: "Syndicates")
    }
    
    func afterLogin() {
        CBSettings.sharedInstance.setCredentials( login.userName, password : login.password )
        SyncManager.sharedInstance.startContinuousReplication(withSettings: CBSettings.sharedInstance)
        if let database = SyncManager.sharedInstance.database {
            print( "afterLogin", login.userName, "has", database.documentCount, "documents" )
        }
        testData = TransactionData.init()
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData!.names.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath)
        cell.textLabel?.text = testData!.names[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let name = testData!.names[indexPath.row]
        let netTransaction = testData!.getNetTransactionsFor(name, currency: "GBP")
        let wheel = Wheel(centerLabel: name, spokes: netTransaction, currency: "GBP")
        WheelViewController.LoadVC(self.storyboard!, nc: self.navigationController!, wheel: wheel, title: name)
    }
}
