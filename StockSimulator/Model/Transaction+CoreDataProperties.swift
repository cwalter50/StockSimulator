//
//  Transaction+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/18/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var buyDate: Date?
    @NSManaged public var costBasis: Double
    @NSManaged public var id: UUID?
    @NSManaged public var isClosed: Bool
    @NSManaged public var numShares: Double
    @NSManaged public var purchasePrice: Double
    @NSManaged public var sellDate: Date?
    @NSManaged public var sellPrice: Double
    @NSManaged public var totalProceeds: Double
    @NSManaged public var account: Account?
    @NSManaged public var stock: Stock?
    @NSManaged public var dividends: NSSet?
    @NSManaged public var splits: Split?

    //    // Cost basis is when we buy
    //    var costBasis: Double {
    //        return numShares * purchasePrice
    //    }
    //
    //    // total proceeds are when we sell
    //    var totalProceeds: Double {
    //        return numShares * sellPrice
    //    }
        
        var currentValue: Double {
            if isClosed == false {
                if let theStock = stock {
                    return theStock.regularMarketPrice * numShares
                }
            }
            return 0.0
        }
        
        func closeTransaction(sellPrice: Double)
        {
            self.sellDate = Date()
            self.isClosed = true
            self.sellPrice = sellPrice
        }
        
        func copyTransaction(from transaction: Transaction)
        {
            // do not copy UUID... Each transaction should be unique...
            self.purchasePrice = transaction.purchasePrice
            self.buyDate = transaction.buyDate
            self.numShares = transaction.numShares
            self.isClosed = transaction.isClosed
            self.sellDate = transaction.sellDate
            self.sellPrice = transaction.sellPrice
            self.stock = transaction.stock
            self.account = transaction.account
        }
        
        func updateValuesFromBuy(account: Account, purchasePrice:Double, numShares: Double)
        {
            self.account = account
            self.id = UUID()
            self.buyDate = Date()
            self.purchasePrice = purchasePrice
            self.numShares = numShares
            self.isClosed = false
            self.costBasis = purchasePrice * numShares
    //        self.totalProceeds = 0 // this should happen by default
        }
}

// MARK: Generated accessors for dividends
extension Transaction {

    @objc(addDividendsObject:)
    @NSManaged public func addToDividends(_ value: Dividend)

    @objc(removeDividendsObject:)
    @NSManaged public func removeFromDividends(_ value: Dividend)

    @objc(addDividends:)
    @NSManaged public func addToDividends(_ values: NSSet)

    @objc(removeDividends:)
    @NSManaged public func removeFromDividends(_ values: NSSet)

}

extension Transaction : Identifiable {

}
