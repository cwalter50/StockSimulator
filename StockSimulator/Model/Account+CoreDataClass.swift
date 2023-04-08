//
//  Account+CoreDataClass.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/18/23.
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
                // see if we already have asset in the assets
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
        
}

