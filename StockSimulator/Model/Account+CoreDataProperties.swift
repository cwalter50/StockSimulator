//
//  Account+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/5/22.
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
    @NSManaged public var holdings: NSSet?

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
            return String(format: "+%.1f", growth) + "%"
        }
        else
        {
            let growth = (1 - currentValue / startingValue) * 100
            return String(format: "-%.1f", growth) + "%"
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

// MARK: Generated accessors for holdings
extension Account {

    @objc(addHoldingsObject:)
    @NSManaged public func addToHoldings(_ value: Holding)

    @objc(removeHoldingsObject:)
    @NSManaged public func removeFromHoldings(_ value: Holding)

    @objc(addHoldings:)
    @NSManaged public func addToHoldings(_ values: NSSet)

    @objc(removeHoldings:)
    @NSManaged public func removeFromHoldings(_ values: NSSet)

}

extension Account : Identifiable {

}
