//
//  Asset.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import Foundation

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
