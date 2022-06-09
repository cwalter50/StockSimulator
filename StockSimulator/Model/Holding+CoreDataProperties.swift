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
    
    var totalShares: Double {
        
        var total = 0.0
        if let theTransactions = transactions?.allObjects as? [Transaction] {
            for transaction in theTransactions {
                if transaction.isClosed == false
                {
                    total += transaction.numShares
                }
            }
        }

        return total
    }
    
    var averagePurchasePrice: Double {
        
        var sum = 0.0
        if let theTransactions = transactions?.allObjects as? [Transaction] {
            for transaction in theTransactions {
                if transaction.isClosed == false
                {
                    sum += transaction.costBasis
                }
            }
        }
        return sum / totalShares
    }
    
    var totalValue: Double {
        if let theStock = stock {
            return totalShares * theStock.regularMarketPrice
        }
        return 0
    }
    
    var costBasis: Double {
        return averagePurchasePrice * totalShares
    }
    
    var percentChange: Double {
        
        if totalValue >= costBasis
        {
            return 100 * (totalValue / costBasis - 1)
        }
        else {
            return 100 * (1 - totalValue / costBasis)
        }
    }
    
    var amountChange: Double {
        return totalValue - costBasis
    }
    
//    init(transactions: [Transaction], stock: Stock)
//    {
//        self.id = UUID()
//        self.transactions = transactions
//        self.stock = stock
//    }
    
    
    func updateValue()
    {
        if let theStock = stock {
            APICaller.shared.getQuoteData(searchSymbols: theStock.wrappedSymbol, completion: { result in
            
                switch result {
                case .success(let snapshots):
                    if let stockSnapshot = snapshots.first(where: { $0.symbol == theStock.wrappedSymbol })
                    {
                        theStock.updateValuesFromStockSnapshot(snapshot: stockSnapshot)
                    }
                default:
                    print("Error updating asset value")
                    
                }
            })
        }

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
