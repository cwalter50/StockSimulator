//
//  Account+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/12/22.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var cash: Double
    @NSManaged public var created: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var startingValue: Double
    @NSManaged public var transactions: NSSet?
    
    
    var assets: [Asset] {

        get {
            return loadAccountAssets()
        }
        set {
            
        }
        
    }
    
    func loadAccountAssets() -> [Asset]
    {
        print("loading account assets")
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
    
    
    

}

extension Account {
    var wrappedName: String {
        name ?? "No Name"
    }
    
    var currentValue: Double {
        var total = cash
        if let theTransactionsSet = self.transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction] {
            for t in theTransactions {
                total += t.currentValue
            }
            
        }
        return total
    }
    
    var percentChange:String {
        if currentValue >= startingValue
        {
            let growth = (currentValue / startingValue - 1) * 100
            return String(format: "+%.1f", growth)
        }
        else
        {
            let growth = (1 - currentValue / startingValue) * 100
            return String(format: "-%.1f", growth)
        }
    }
}


// MARK: Generated accessors for transactions
extension Account {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Account : Identifiable {

}
