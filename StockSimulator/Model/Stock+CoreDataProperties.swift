//
//  Stock+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/24/22.
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
    @NSManaged public var longName: String?
    @NSManaged public var market: String?
    @NSManaged public var quoteType: String?
    @NSManaged public var regularMarketChange: Double
    @NSManaged public var regularMarketChangePercent: Double
    @NSManaged public var regularMarketDayHigh: Double
    @NSManaged public var regularMarketDayLow: Double
    @NSManaged public var regularMarketPrice: Double
    @NSManaged public var shortName: String?
    @NSManaged public var symbol: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var tradeable: Bool
    @NSManaged public var earningsTimestamp: Int32
    @NSManaged public var trailingAnnualDividendRate: Double
    @NSManaged public var trailingPE: Double
    @NSManaged public var trailingAnnualDividendYield: Double
    @NSManaged public var epsTrailingTwelveMonths: Double
    @NSManaged public var epsForward: Double
    @NSManaged public var epsCurrentYear: Double
    @NSManaged public var priceEpsCurrentYear: Double
    @NSManaged public var sharesOutstanding: Int64
    @NSManaged public var bookValue: Double
    @NSManaged public var fiftyDayAverage: Double
    @NSManaged public var fiftyDayAverageChange: Double
    @NSManaged public var fiftyDayAverageChangePercent: Double
    @NSManaged public var twoHundredDayAverage: Double
    @NSManaged public var twoHundredDayAverageChange: Double
    @NSManaged public var twoHundredDayAverageChangePercent: Double
    @NSManaged public var marketCap: Int64
    @NSManaged public var forwardPE: Double
    @NSManaged public var priceToBook: Double
    @NSManaged public var averageAnalystRating: String?
    @NSManaged public var priceHint: Int32
    @NSManaged public var postMarketChangePercent: Double
    @NSManaged public var postMarketTime: Int32
    @NSManaged public var postMarketPrice: Double
    @NSManaged public var postMarketChange: Double
    @NSManaged public var regularMarketTime: Int32
    @NSManaged public var regularMarketDayRange: String?
    @NSManaged public var regularMarketVolume: Int32
    @NSManaged public var regularMarketPreviousClose: Double
    @NSManaged public var bidSize: Int32
    @NSManaged public var askSize: Int32
    @NSManaged public var fullExchangeName: String?
    @NSManaged public var financialCurrency: String?
    @NSManaged public var regularMarketOpen: Double
    @NSManaged public var averageDailyVolume3Month: Int32
    @NSManaged public var averageDailyVolume10Day: Int32
    @NSManaged public var fiftyTwoWeekLowChange: Double
    @NSManaged public var fiftyTwoWeekRange: String?
    @NSManaged public var fiftyTwoWeekHighChange: Double
    @NSManaged public var fiftyTwoWeekHighChangePercent: Double
    @NSManaged public var fiftyTwoWeekLow: Double
    @NSManaged public var fiftyTwoWeekHigh: Double
    @NSManaged public var dividendDate: Int32
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
        
        dividendDate = Int32(snapshot.dividendDate ?? 0)
        tradeable = snapshot.tradeable
        earningsTimestamp = Int32(snapshot.earningsTimestamp ?? 0)
        
        trailingAnnualDividendRate = snapshot.trailingAnnualDividendRate
        
        trailingPE = snapshot.trailingPE ?? 0
        trailingAnnualDividendYield = snapshot.trailingAnnualDividendYield
        epsTrailingTwelveMonths = snapshot.epsTrailingTwelveMonths
        epsForward = snapshot.epsForward
        epsCurrentYear = snapshot.epsCurrentYear
        priceEpsCurrentYear = snapshot.priceEpsCurrentYear
        
        sharesOutstanding = Int64(snapshot.sharesOutstanding)
        bookValue = snapshot.bookValue
        fiftyDayAverage = snapshot.fiftyDayAverage
        fiftyDayAverageChange = snapshot.fiftyDayAverageChange
        fiftyDayAverageChangePercent = snapshot.fiftyDayAverageChangePercent
        twoHundredDayAverage = snapshot.twoHundredDayAverage
        twoHundredDayAverageChange = snapshot.twoHundredDayAverageChange
        twoHundredDayAverageChangePercent = snapshot.twoHundredDayAverageChangePercent
        marketCap = Int64(snapshot.marketCap)
        forwardPE = snapshot.forwardPE
        priceToBook = snapshot.priceToBook
        averageAnalystRating = snapshot.averageAnalystRating
        priceHint = Int32(snapshot.priceHint)
        postMarketChangePercent = snapshot.postMarketChangePercent
        postMarketTime = Int32(snapshot.postMarketTime)
        postMarketPrice = snapshot.postMarketPrice
        postMarketChange = snapshot.postMarketChange
        regularMarketTime = Int32(snapshot.regularMarketTime)
        regularMarketDayRange = snapshot.regularMarketDayRange

        regularMarketVolume = Int32(snapshot.regularMarketVolume)
        regularMarketPreviousClose = snapshot.regularMarketPreviousClose
        bidSize = Int32(snapshot.bidSize)
        askSize = Int32(snapshot.askSize)
        fullExchangeName = snapshot.fullExchangeName
        financialCurrency = snapshot.financialCurrency
        regularMarketOpen = snapshot.regularMarketOpen
        averageDailyVolume3Month = Int32(snapshot.averageDailyVolume3Month)
        averageDailyVolume10Day = Int32(snapshot.averageDailyVolume10Day)
        fiftyTwoWeekLowChange = snapshot.fiftyTwoWeekLowChange
        fiftyTwoWeekRange = snapshot.fiftyTwoWeekRange
        fiftyTwoWeekHighChange = snapshot.fiftyTwoWeekHighChange
        fiftyTwoWeekHighChangePercent = snapshot.fiftyTwoWeekHighChangePercent
        fiftyTwoWeekLow = snapshot.fiftyTwoWeekLow
        fiftyTwoWeekHigh = snapshot.fiftyTwoWeekHigh
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
