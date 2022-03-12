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
    
    var wrappedName: String {
        name ?? "No Name"
    }
    
    func calculateValue() -> Double
    {
        var total = cash
//        for asset in assets {
//            total += asset.totalShares * asset.stock.regularMarketPrice
//        }

        return total

    }
    
    func calculatePercentChange() -> String
    {
        let currentValue = calculateValue()
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
