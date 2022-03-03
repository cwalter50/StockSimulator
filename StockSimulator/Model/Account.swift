////
////  Account.swift
////  StockSimulator
////
////  Created by Christopher Walter on 2/1/22.
////
//
//import Foundation
//
//class Account: ObservableObject, Codable, Identifiable
//{
//    var id: UUID
//    
//    var name: String
//    var cash: Double
//    var assets: [Asset]
//    var startingValue: Double
//    
//    
//    init ()
//    {
//        id = UUID()
//        name = "Test"
//        cash = 10000
//        assets = []
//        startingValue = 10000
//    }
//    
//    init (name: String, cash: Double)
//    {
//        self.name = name
//        self.cash = cash
//        self.assets = []
//        id = UUID()
//        startingValue = cash
//    }
//    
//    func calculateValue() -> Double
//    {
//        var total = cash
//        for asset in assets {
//            total += asset.totalShares * asset.stock.regularMarketPrice
//        }
//        
//        return total
//        
//    }
//    
//    func calculatePercentChange() -> String
//    {
//        let currentValue = calculateValue()
//        if currentValue >= startingValue
//        {
//            let growth = (currentValue / startingValue - 1) * 100
//            return String(format: "+%.1f", growth)
//        }
//        else
//        {
//            let growth = (1 - currentValue / startingValue) * 100
//            return String(format: "-%.1f", growth)
//        }
//    }
//    
//    func canAffordTrade(numShares: Double, stock: Stock) -> Bool
//    {
//        return numShares * stock.regularMarketPrice >= cash
//    }
//    
//    func canSellAsset(numShares: Double, stock: Stock) -> Bool
//    {
//        for asset in assets {
//            if asset.stock.symbol == stock.symbol && asset.totalShares >= numShares
//            {
//                return true
//            }
//        }
//        return false
//    }
//    
//    // returns true if transaction was success, false otherwise
//    func buyAsset(numShares: Double, stock: Stock) -> Bool
//    {
//        if canAffordTrade(numShares: numShares, stock: stock) {
//            // check if you already have the asset and add to the amount of the asset
//            if let current = assets.first(where: {$0.stock.symbol == stock.symbol})
//            {
//                current.addShares(numShares: numShares, price: stock.regularMarketPrice)
//            }
//            else {
//                let newAsset = Asset(stock: stock, numShares: numShares)
//                assets.append(newAsset)
//            }
//            
//            cash -= numShares * stock.regularMarketPrice
//            return true
//        }
//        else {
//            return false
//        }
//    }
//    
//    // this will return true if sale
//    func sellAsset(numShares: Double, stock:Stock) -> Bool
//    {
//        for i in 0..<assets.count
//        {
//            let asset = assets[i]
//            if asset.stock.symbol == stock.symbol {
//                if numShares <= asset.totalShares
//                {
//                    asset.sellShares(numShares: numShares, price: stock.regularMarketPrice)
//                    cash += numShares * stock.regularMarketPrice
//                }
//                else {
//                    return false // trying to sell more shares than you have
//                }
//                // check if you sold all of your shares.
//                if asset.totalShares <= 0
//                {
//                    assets.remove(at: i)
//                }
//                return true
//            }
//        }
//
//        return false
//    }
//    
//}
