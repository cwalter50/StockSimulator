//
//  Stock+CoreDataClass.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/4/22.
//
//

import Foundation
import CoreData
import SwiftUI


public class Stock: NSManagedObject {
    
    // This is used to make up sample data to test...
//    init()
//    {
//        
//
//    super.init(entity: NSEntityDescription(), insertInto: nil)
//
////    quoteType: "EQUITY", displayName: "Apple", currency: "USD", symbol: "AAPL", language: "en-US", ask: 168.24, bid: 168.41, market: "us_market", regularMarketDayHigh: 173.08, regularMarketDayLow: 168.04, regularMarketPrice: 168.64)
//        // sample stock...
//        
//        
//        self.quoteType = "EQUITY"
//        self.displayName = "Apple"
//        self.currency = "USD"
//        self.symbol = "AAPL"
//        self.language = "en-US"
//        self.ask = 168.24
//        self.bid = 168.41
//        self.market = "us_market"
//        self.regularMarketDayHigh = 173.08
//        self.regularMarketDayLow = 168.04
//        self.regularMarketPrice = 168.64
//        
//        self.id = UUID()
//        self.timeStamp = Date()
//
//    }
    
//    init(stockSnapshot: StockSnapshot)
//    {
//        let moc = DataController().container.viewContext
//        
//        
//        super.init(entity: NSEntityDescription(), insertInto: moc)
//
//        self.quoteType = stockSnapshot.quoteType
//        self.displayName = stockSnapshot.displayName
//        self.currency = stockSnapshot.currency
//        self.symbol = stockSnapshot.symbol
//        self.language = stockSnapshot.language
//        self.ask = stockSnapshot.ask
//        self.bid = stockSnapshot.bid
//        self.market = stockSnapshot.market
//        self.regularMarketDayHigh = stockSnapshot.regularMarketDayHigh
//        self.regularMarketDayLow = stockSnapshot.regularMarketDayLow
//        self.regularMarketPrice = stockSnapshot.regularMarketPrice
//        self.id = stockSnapshot.id
//        self.timeStamp = Date()
//
//    }

}
