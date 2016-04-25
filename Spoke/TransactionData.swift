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
    var brokerDataSet: [Wheel]?
    var syndicateDataSet: [Wheel]?
    
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
    
    func getNetTransactionsFor(name: String, currency: String) -> [NetTransaction] {
        let filteredTransactions = TransactionFuncs.getTransactionsFor(transactions, name: name, currency: currency)
        print("filtered transaction count is", filteredTransactions.count)
        return TransactionFuncs.getNetTransactions(filteredTransactions, name: name, currency: currency)
        //return getWheelsFor([name], currencies: [currency])
    }
    
    func getBrokerDataSet() -> [Wheel] {
        if brokerDataSet == nil {
            brokerDataSet = getWheelsFor(brokers, currencies: currencies)
        }
        return brokerDataSet!
    }
    
    func getSyndDataSet() -> [Wheel] {
        if syndicateDataSet == nil {
            syndicateDataSet = getGroupDataSet(syndicates, currencies: currencies)
            //syndicateDataSet = getWheelsFor(syndicates, currencies: currencies)
        }
        return syndicateDataSet!
    }
    
    private func getGroupDataSet(names: [String], currencies: [String]) -> [Wheel] {
        var wheels = [Wheel]()
        for name in names {
            for currency in currencies {
                let netTransactions = getNetTransactionsFor(name , currency: currency)
                wheels.append(Wheel(centerLabel: name, currency: currency))
            }
        }
        return wheels
    }
    
    func getWheelsFor(names: [String], currencies: [String]) -> [Wheel] {
        var wheels = [Wheel]()
        let filteredTransactions = filterTransactions(names, currencies: currencies)
        print("filtered transaction count is", filteredTransactions.count)
        //let singleTransactions = aggregateTransactions(filteredTransactions)
        
        for name in names {
            for currency in currencies {
                let netTransactions = TransactionFuncs.getNetTransactions(filteredTransactions, name: name, currency: currency)
                let wheel = Wheel(centerLabel: name, currency: currency)
                wheels.append(wheel)
            }
        }
        
        return wheels
    }
    
//    private func aggregateTransactions(transactions: [Transaction]) -> [Transaction] {
//        var singleTransactions = [Transaction]()
//        
//        for transaction in transactions {
//            if singleTransactions.contains( {$0.payee == transaction.payee && $0.payer == transaction.payer && $0.currency == transaction.currency} ) {
//                let idx = singleTransactions.indexOf({$0.payee == transaction.payee && $0.payer == transaction.payer && $0.currency == transaction.currency})
//                singleTransactions[idx!].addAmount(transaction.amount)
//            } else {
//                singleTransactions.append(transaction)
//            }
//        }
//        return singleTransactions
//    }
    
    private func filterTransactions(names: [String], currencies: [String]) -> [Transaction] {
        var result = [Transaction]()
        
        for transaction in transactions {
            if currencies.contains(transaction.currency) && (names.contains(transaction.payee) || names.contains(transaction.payer)) {
                result.append(transaction)
            }
        }
        
        return result
    }
}