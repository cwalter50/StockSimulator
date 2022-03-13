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
    @NSManaged public var buyDate: Date?
    @NSManaged public var numShares: Double
    @NSManaged public var costBasis: Double
    @NSManaged public var isClosed: Bool
    @NSManaged public var totalProceeds: Double
    @NSManaged public var sellDate: Date?
    @NSManaged public var stock: Stock?
    @NSManaged public var account: Account?
    
    
    var currentValue: Double {
        if isClosed == false {
            if let theStock = stock {
                return theStock.regularMarketPrice * numShares
            }
        }
        return 0.0
    }

}

extension Transaction : Identifiable {

}
