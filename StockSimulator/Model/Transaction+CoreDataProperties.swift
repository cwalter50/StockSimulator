//
//  Transaction+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/12/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var purchasePrice: Double
    @NSManaged public var timeStamp: Date?
    @NSManaged public var totalShares: Double
    @NSManaged public var stock: Stock?
    @NSManaged public var account: Account?

}

extension Transaction : Identifiable {

}
