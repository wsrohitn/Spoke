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

class MenuTVCTableViewController: UITableViewController {
    var names: [String] = []
    
    var testData = [Transaction]()
    
    var login = Login(forUrl: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login = Login( forUrl: CBSettings.sharedInstance.url )
        if login.isValid {
            afterLogin()
        } else {
            self.view.userInteractionEnabled = false
            doLogin()
        }
        
    }
    func afterLogin() {
        CBSettings.sharedInstance.setCredentials( login.userName, password : login.password )
        SyncManager.sharedInstance.startContinuousReplication(withSettings: CBSettings.sharedInstance)
        if let database = SyncManager.sharedInstance.database {
            print( "afterLogin", login.userName, "has", database.documentCount, "documents" )
        }
        loadData()
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
    
    func loadData() {
        print("trying to load db")
        guard let db = SyncManager.sharedInstance.database else {
            return
        }
        
        if let doc = db.existingDocumentWithID("SpokeTestData") {
            if let props = doc.properties {
                let datas = props.getArrayOfDictionaries("data")
                
                for data in datas {
                    let amount = NSDecimalNumber(double: data.getDouble("amount"))
                    testData.append(Transaction(payer: data.getString("payer"), payee: data.getString("payee"), amount: amount, currency: data.getString("currency"), year: data.getInt("year"), month: data.getInt("month"), day: data.getInt("day")))
                }
            }
        }
        
        print("test data has", testData.count)
        getNames()
        names.sortInPlace()
    }
    
    func getNames() {
        for transaction in testData {
            if !names.contains(transaction.payee) {
                names.append(transaction.payee)
            }
            if !names.contains(transaction.payer) {
                names.append(transaction.payer)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath)
        cell.textLabel?.text = names[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let name = names[indexPath.row]
        WheelViewController.LoadVC(self.storyboard!, nc: self.navigationController!, transactions: testData, title: name)
    }

}
