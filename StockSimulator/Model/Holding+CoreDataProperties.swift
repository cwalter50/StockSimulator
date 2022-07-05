//
//  Holding+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/5/22.
//
//

import Foundation
import CoreData


extension Holding {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Holding> {
        return NSFetchRequest<Holding>(entityName: "Holding")
    }

    @NSManaged public var created: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var numShares: Double
    @NSManaged public var symbol: String?
    @NSManaged public var account: Account?
    @NSManaged public var dividends: NSSet?
    @NSManaged public var splits: NSSet?
    @NSManaged public var stock: Stock?
    @NSManaged public var transactions: NSSet?

}

extension Holding {
    var wrappedSymbol: String {
        return symbol ?? "No Symbol"
    }
    
    var averagePurchasePrice: Double {
        
        var sum = 0.0
        
        if let theTransactionsSet = transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction]
        {
            for t in theTransactions {
                if t.isClosed == false {
                    sum += t.costBasis
                }
            }
        }
        return sum / numShares
    }
    
    var totalValue: Double {
        if let theStock = stock {
            return numShares * theStock.regularMarketPrice
        }
        else {
            return 0
        }
        
    }
    
    var costBasis: Double {
        return averagePurchasePrice * numShares
    }
    
    var percentChange: Double {
        
        if totalValue > costBasis
        {
            return 100 * (totalValue / costBasis - 1)
        }
        else {
            return 100 * (1 - totalValue / costBasis)
        }
    }
    
    var amountChange24h: Double {
        if let theStock = stock {
            return theStock.regularMarketChange * numShares
        }
        else {
            return 0
        }
        
    }
    var amountChange: Double {
        return totalValue - costBasis
    }
}

// MARK: Generated accessors for dividends
extension Holding {

    @objc(addDividendsObject:)
    @NSManaged public func addToDividends(_ value: Dividend)

    @objc(removeDividendsObject:)
    @NSManaged public func removeFromDividends(_ value: Dividend)

    @objc(addDividends:)
    @NSManaged public func addToDividends(_ values: NSSet)

    @objc(removeDividends:)
    @NSManaged public func removeFromDividends(_ values: NSSet)

}

// MARK: Generated accessors for splits
extension Holding {

    @objc(addSplitsObject:)
    @NSManaged public func addToSplits(_ value: Split)

    @objc(removeSplitsObject:)
    @NSManaged public func removeFromSplits(_ value: Split)

    @objc(addSplits:)
    @NSManaged public func addToSplits(_ values: NSSet)

    @objc(removeSplits:)
    @NSManaged public func removeFromSplits(_ values: NSSet)

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
