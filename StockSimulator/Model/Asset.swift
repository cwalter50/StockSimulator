//
//  Asset.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import Foundation


class Asset: Identifiable
{
    var transactions: [Transaction]
    var id: UUID
    
    var stock: Stock
    
    var totalShares: Double {
        
        var total = 0.0
        for transaction in transactions {
            if transaction.isClosed == false
            {
                total += transaction.numShares
            }
        }
        return total
    }
    
    var averagePurchasePrice: Double {
        
        var sum = 0.0
        for transaction in transactions {
            if transaction.isClosed == false
            {
                sum += transaction.costBasis
            }
        }
        return sum / totalShares
    }
    
    var totalValue: Double {
        return totalShares * stock.regularMarketPrice
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
    
    init(transactions: [Transaction], stock: Stock)
    {
        self.id = UUID()
        self.transactions = transactions
        self.stock = stock
        
    }
    
    
}

//class Asset: Identifiable
//{
//    var id: UUID // satisfies Identifiable and helps with lists
//    var transactions: [Transaction]
//    var stock : Stock
//    var totalShares: Double
//    var averagePurchasePrice: Double
//    
//    init(stock: Stock)
//    {
//        transactions = []
//        self.stock = stock
//        totalShares = 0
//        averagePurchasePrice = stock.regularMarketPrice
//        id = UUID()
//        
//    }
//    
//    init(transactions: [Transaction], stock: Stock)
//    {
//        // make sure transactions are in the correct date order...
//        self.transactions = transactions
//        
//        self.stock = stock
//        self.id = UUID()
//        self.totalShares = 0
//        
//        averagePurchasePrice = 0
//        
//        var currentHoldings = [Transaction]()
//        for transaction in transactions {
//            if transaction.isBuy == true
//            {
//                totalShares += transaction.numShares
//                currentHoldings.append(transaction)
//            }
//            else
//            {
//                totalShares -= transaction.numShares
//                currentHoldings.append(transaction)
////                totalCostBasis -=
//                if totalShares <= 0
//                {
//                    currentHoldings.removeAll()
//                }
//            }
//        }
//
//        averagePurchasePrice = stock.regularMarketPrice
//        
//    }
//    
//    func addTransaction(transaction : Transaction)
//    {
//        transactions.append(transaction)
//        
//        var total = 0
//        for transaction in transactions {
//            
//        }
//        
//    }
//    
//    func calculateData()
//    {
//        
//    }
//    
//}

// This is the asset that we are buying and currently hold
//class Asset: Codable, Identifiable
//{
//    var id: UUID // satisfies Identifiable and Codable for encoding and decoding
//    
//    var stock: Stock
//    var totalShares: Double
//    var averagePurchasePrice: Double
//    
//    var buyPoints: [BuyPoint]
//    
//    init(stock: Stock, numShares: Double)
//    {
//        id = UUID()
//        self.stock = stock
//        self.totalShares = numShares
//        self.averagePurchasePrice = stock.regularMarketPrice
//        
//        buyPoints = [BuyPoint(numShares: numShares, purchasePrice: stock.regularMarketPrice)]
//    }
//    
//    func addShares(numShares: Double, price: Double)
//    {
//        
//        totalShares += numShares
//        buyPoints.append(BuyPoint(numShares: numShares, purchasePrice: price))
//        // update average purchase price
//        var sum = 0.0
//        for buyPoint in buyPoints {
//            sum += buyPoint.numShares * buyPoint.purchasePrice
//        }
//        averagePurchasePrice = sum / totalShares
//        
//    }
//    
//    func sellShares(numShares: Double, price: Double)
//    {
//        totalShares -= numShares
//        buyPoints.append(BuyPoint(numShares: -1*numShares, purchasePrice: price))
//        
//        // update average purchase price
//        var sum = 0.0
//        for buyPoint in buyPoints {
//            sum += buyPoint.numShares * buyPoint.purchasePrice
//        }
//        averagePurchasePrice = sum / totalShares
//    }
//    
//    
//    
//
//}
//
//struct BuyPoint: Codable {
//    var numShares: Double
//    var purchasePrice: Double
//}
