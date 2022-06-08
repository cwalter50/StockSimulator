//
//  Holding+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/8/22.
//
//

import Foundation
import CoreData


extension Holding {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Holding> {
        return NSFetchRequest<Holding>(entityName: "Holding")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var symbol: String?
    @NSManaged public var account: Account?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var stock: Stock?

}

extension Holding {
    var wrappedSymbol: String {
        symbol ?? "Unknown"
    }
}

// MARK: Generated accessors for transactions
extension Holding {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Holding : Identifiable {

}
