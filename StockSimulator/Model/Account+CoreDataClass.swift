//
//  Account+CoreDataClass.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/5/22.
//
//

import Foundation
import CoreData


public class Account: NSManagedObject {
    
    //    @Published var assets: [Asset] = []
    
    func loadAssets() -> [Asset]
    {
        var theAssets = [Asset]()
        if let theTransactionsSet = transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction]
        {
            for t in theTransactions {
                // see if I already have asset in the assets
                if let foundAsset = theAssets.first(where: {$0.stock.wrappedSymbol == t.stock?.wrappedSymbol}) {
                    foundAsset.transactions.append(t)
                }
                else {
                    // make a new asset and add it to theAssets
                    if let theStock = t.stock {
                        let newAsset = Asset(transactions: [t], stock: theStock)
                        theAssets.append(newAsset)
                    }
                }
            }
        }
        return theAssets
    }
    var assets: [Asset] {
        var theAssets = [Asset]()
        if let theTransactionsSet = transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction]
        {
            for t in theTransactions {
                // see if I already have asset in the assets
                if let foundAsset = theAssets.first(where: {$0.stock.wrappedSymbol == t.stock?.wrappedSymbol}) {
                    foundAsset.transactions.append(t)
                }
                else {
                    // make a new asset and add it to theAssets
                    if let theStock = t.stock {
                        let newAsset = Asset(transactions: [t], stock: theStock)
                        theAssets.append(newAsset)
                    }
                }
            }
        }
        return theAssets
    }
        
        
        
    //    var assets: [Asset] {
    //        get {
    //            return loadAccountAssets()
    //        }
    //        set {
    ////            self.assets = loadAccountAssets()
    //        }
    //    }
        
    //    func loadAccountAssets() -> [Asset]
    //    {
    ////        print("loading account assets")
    //        var theAssets = [Asset]()
    //        if let theTransactionsSet = transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction]
    //        {
    //            for t in theTransactions {
    //                // see if I already have asset in the assets
    //                if let foundAsset = theAssets.first(where: {$0.stock.wrappedSymbol == t.stock?.wrappedSymbol}) {
    //                    foundAsset.transactions.append(t)
    //                }
    //                else {
    //                    // make a new asset and add it to theAssets
    //                    if let theStock = t.stock {
    //                        let newAsset = Asset(transactions: [t], stock: theStock)
    //                        theAssets.append(newAsset)
    //                    }
    //                }
    //            }
    //        }
    //        return theAssets
    //    }
}


    





