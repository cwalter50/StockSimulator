//
//  Stock+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 4/27/22.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var ask: Double
    @NSManaged public var bid: Double
    @NSManaged public var currency: String?
    @NSManaged public var displayName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var language: String?
    @NSManaged public var market: String?
    @NSManaged public var quoteType: String?
    @NSManaged public var regularMarketDayHigh: Double
    @NSManaged public var regularMarketDayLow: Double
    @NSManaged public var regularMarketPrice: Double
    @NSManaged public var symbol: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var regularMarketChange: Double
    @NSManaged public var regularMarketChangePercent: Double
    @NSManaged public var shortName: String?
    @NSManaged public var longName: String?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var watchlists: NSSet?

}

extension Stock {
    var wrappedSymbol: String {
        symbol ?? "Unknown"
    }
    
    var wrappedDisplayName: String {
        if let disp = displayName {
            return disp
        }
        else if let short = shortName {
            return short
        }
        else if let long = longName {
            return long
        }
        else
        {
            return "Unknown"
        }
    }
    
    var regularMarketChangeFormatted: String {
        if regularMarketChange < 0 {
            let value = regularMarketChange * -1
            return String(format: "-$%.2f", value)
        }
        else {
            return String(format: "+$%.2f", regularMarketChange)
        }
        
    }
    
    var regularMarketChangePercentFormatted: String {
        if regularMarketChangePercent < 0 {
            let value = regularMarketChangePercent * -1
            return String(format: "-%.2f", value) + "%"
        }
        else {
            return String(format: "+%.2f", regularMarketChangePercent) + "%"
        }
        
    }
    
    func updateValuesFromStockSnapshot(snapshot: StockSnapshot)
    {
        self.quoteType = snapshot.quoteType
        self.displayName = snapshot.displayName
        self.currency = snapshot.currency
        self.symbol = snapshot.symbol
        self.language = snapshot.language
        self.ask = snapshot.ask
        self.bid = snapshot.bid
        self.market = snapshot.market
        self.regularMarketDayLow = snapshot.regularMarketDayLow
        self.regularMarketDayHigh = snapshot.regularMarketDayHigh
        self.regularMarketPrice = snapshot.regularMarketPrice
        self.id = snapshot.id
        self.timeStamp = Date()
        self.regularMarketChange = snapshot.regularMarketChange
        self.regularMarketChangePercent = snapshot.regularMarketChangePercent
        self.shortName = snapshot.shortName
        self.longName = snapshot.longName
    }

}

// MARK: Generated accessors for transactions
extension Stock {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

// MARK: Generated accessors for watchlists
extension Stock {

    @objc(addWatchlistsObject:)
    @NSManaged public func addToWatchlists(_ value: Watchlist)

    @objc(removeWatchlistsObject:)
    @NSManaged public func removeFromWatchlists(_ value: Watchlist)

    @objc(addWatchlists:)
    @NSManaged public func addToWatchlists(_ values: NSSet)

    @objc(removeWatchlists:)
    @NSManaged public func removeFromWatchlists(_ values: NSSet)

}

extension Stock : Identifiable {

}
