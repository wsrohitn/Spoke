//
//  TransactionData.swift
//  Spoke
//
//  Created by Rohit Natarajan on 22/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import Foundation
import WsBase
import WsCouchBasic

class TransactionData {
    var transactions = [Transaction]()
    var names = [String]()
    var currencies = [String]()
    var syndicates = [String]()
    var brokers = [String]()
    var brokerDataSet: StringKeyDict?
    var syndicateDataSet: StringKeyDict?
    
    init() {
        loadData()
        self.names = TransactionFuncs.getAllNames(transactions)
        let groupedNames = TransactionFuncs.getSyndAndBrokerNames(self.names)
        self.brokers = groupedNames.brokerNames
        self.syndicates = groupedNames.syndNames
        self.currencies = TransactionFuncs.getCurrencies(transactions)
    }
    
    func loadData() {
        guard let db = SyncManager.sharedInstance.database, doc = db.existingDocumentWithID("SpokeTestData"), props = doc.properties else {
            return
        }
        
        let datas = props.getArrayOfDictionaries("data")
        for data in datas {
            let amount = NSDecimalNumber(double: data.getDouble("amount"))
            transactions.append(Transaction(payer: data.getString("payer"), payee: data.getString("payee"), amount: amount, currency: data.getString("currency"), year: data.getInt("year"), month: data.getInt("month"), day: data.getInt("day")))
        }
        print("we have \(transactions.count) transactions")
    }
    
    func getNetTransactionsFor(name: String, currency: String) -> [String: NSDecimalNumber] {
        let filteredTransactions = TransactionFuncs.getTransactionsFor(transactions, name: name)
        return TransactionFuncs.getNetTransactions(filteredTransactions, name: name, currency: currency)
    }
    
    func getBrokerDataSet() -> StringKeyDict {
        if brokerDataSet == nil {
            brokerDataSet = getGroupDataSet(brokers)
        }
        return brokerDataSet!
    }
    
    func getSyndDataSet() -> StringKeyDict {
        if syndicateDataSet == nil {
            syndicateDataSet = getGroupDataSet(syndicates)
        }
        return syndicateDataSet!
    }
    
    private func getGroupDataSet(names: [String]) -> StringKeyDict {
        var dict = StringKeyDict()
        for name in names {
            var bkrDict = StringKeyDict()
            
            for currency in currencies {
                bkrDict[currency] = getNetTransactionsFor(name , currency: currency)
            }
            dict[name] = bkrDict
        }
        return dict
    }
}