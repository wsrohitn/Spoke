//
//  CBSettings.swift
//  Atomicity
//
//  Created by Rohit Natarajan on 11/04/2016.
//  Copyright © 2016 Jonathan Clarke. All rights reserved.
//

import Foundation
import WsBase
import WsCouchBasic

public protocol CBSettingsProtocol {
    var hostName: String {
        get
    }
    var bucketName: String {
        get
    }
}

class CBSettings : CBLocalDatabaseSettings, CBReplicationSettings, CBSettingsProtocol {
    
    static let sharedInstance = CBSettings()
    
    let hostName = "https://abse.whitespace.co.uk"
    let bucketName = "simulator"
    let name = "localdatabase"
    let url = "https://abse.whitespace.co.uk/simulator"
    
    private var _userName : String?
    private var _password : String?
    
    var userName: String? { return _userName }
    var password: String? { return _password }
    
    func setCredentials( userName : String?, password : String? )
    {
        _userName = userName
        _password = password
    }
    
    func initialiseViews(forDatabase database: CBLDatabase) {
        print("Initialise views for database")
    }
    
    var filteredPullChannels: [String]? {
        return nil
    }
    
    var allowPush: Bool {
        return true
    }
}
