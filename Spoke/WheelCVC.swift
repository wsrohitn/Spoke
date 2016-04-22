//
//  WheelCVC.swift
//  Spoke
//
//  Created by Rohit Natarajan on 22/04/2016.
//  Copyright © 2016 Rohit Natarajan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class WheelCVC: UICollectionViewController {
    var transactions: [Transaction]?
    
    
//    static func LoadVC( sb : UIStoryboard, nc : UINavigationController, transactions: [Transaction], title: String) {
//        if let vc = sb.instantiateViewControllerWithIdentifier("WheelViewController") as? WheelViewController {
//            nc.pushViewController(vc, animated: true)
//            vc.setInitialState(title, netTransactions: transactions)
//        }
//    }
//    
//    func setInitialState(title: String, transactions: [Transaction]) {
//        self.title = title
//        self.transactions = transactions
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }

}
