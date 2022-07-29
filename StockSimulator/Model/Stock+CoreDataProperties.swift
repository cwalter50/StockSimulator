//
//  Stock+CoreDataProperties.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/27/22.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var ask: Double
    @NSManaged public var askSize: Int32
    @NSManaged public var averageAnalystRating: String?
    @NSManaged public var averageDailyVolume3Month: Int64
    @NSManaged public var averageDailyVolume10Day: Int64
    @NSManaged public var bid: Double
    @NSManaged public var bidSize: Int32
    @NSManaged public var bookValue: Double
    @NSManaged public var currency: String?
    @NSManaged public var displayName: String?
    @NSManaged public var dividendDate: Int32
    @NSManaged public var earningsTimestamp: Int32
    @NSManaged public var epsCurrentYear: Double
    @NSManaged public var epsForward: Double
    @NSManaged public var epsTrailingTwelveMonths: Double
    @NSManaged public var fiftyDayAverage: Double
    @NSManaged public var fiftyDayAverageChange: Double
    @NSManaged public var fiftyDayAverageChangePercent: Double
    @NSManaged public var fiftyTwoWeekHigh: Double
    @NSManaged public var fiftyTwoWeekHighChange: Double
    @NSManaged public var fiftyTwoWeekHighChangePercent: Double
    @NSManaged public var fiftyTwoWeekLow: Double
    @NSManaged public var fiftyTwoWeekLowChange: Double
    @NSManaged public var fiftyTwoWeekRange: String?
    @NSManaged public var financialCurrency: String?
    @NSManaged public var forwardPE: Double
    @NSManaged public var fullExchangeName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var language: String?
    @NSManaged public var longName: String?
    @NSManaged public var market: String?
    @NSManaged public var marketCap: Int64
    @NSManaged public var postMarketChange: Double
    @NSManaged public var postMarketChangePercent: Double
    @NSManaged public var postMarketPrice: Double
    @NSManaged public var postMarketTime: Int32
    @NSManaged public var priceEpsCurrentYear: Double
    @NSManaged public var priceHint: Int32
    @NSManaged public var priceToBook: Double
    @NSManaged public var quoteType: String?
    @NSManaged public var regularMarketChange: Double
    @NSManaged public var regularMarketChangePercent: Double
    @NSManaged public var regularMarketDayHigh: Double
    @NSManaged public var regularMarketDayLow: Double
    @NSManaged public var regularMarketDayRange: String?
    @NSManaged public var regularMarketOpen: Double
    @NSManaged public var regularMarketPreviousClose: Double
    @NSManaged public var regularMarketPrice: Double
    @NSManaged public var regularMarketTime: Int32
    @NSManaged public var regularMarketVolume: Int64
    @NSManaged public var sharesOutstanding: Int64
    @NSManaged public var shortName: String?
    @NSManaged public var symbol: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var tradeable: Bool
    @NSManaged public var trailingAnnualDividendRate: Double
    @NSManaged public var trailingAnnualDividendYield: Double
    @NSManaged public var trailingPE: Double
    @NSManaged public var twoHundredDayAverage: Double
    @NSManaged public var twoHundredDayAverageChange: Double
    @NSManaged public var twoHundredDayAverageChangePercent: Double
    @NSManaged public var circulatingSupply: Int64
    @NSManaged public var lastMarket: String?
    @NSManaged public var volume24Hr: Int64
    @NSManaged public var volumeAllCurrencies: Int64
    @NSManaged public var fromCurrency: String?
    @NSManaged public var toCurrency: String?
    @NSManaged public var coinMarketCapLink: String?
    @NSManaged public var startDate: Int32
    @NSManaged public var coinImageURL: String?
    @NSManaged public var logoURL: String?
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
        self.ask = snapshot.ask ?? 0
        self.bid = snapshot.bid ?? 0
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

        trailingAnnualDividendRate = snapshot.trailingAnnualDividendRate ?? 0

        trailingPE = snapshot.trailingPE ?? 0
        trailingAnnualDividendYield = snapshot.trailingAnnualDividendYield ?? 0
        epsTrailingTwelveMonths = snapshot.epsTrailingTwelveMonths ?? 0
        epsForward = snapshot.epsForward ?? 0
        epsCurrentYear = snapshot.epsCurrentYear ?? 0
        priceEpsCurrentYear = snapshot.priceEpsCurrentYear ?? 0

        sharesOutstanding = Int64(snapshot.sharesOutstanding ?? 0)
        bookValue = snapshot.bookValue ?? 0
        fiftyDayAverage = snapshot.fiftyDayAverage ?? 0
        fiftyDayAverageChange = snapshot.fiftyDayAverageChange ?? 0
        fiftyDayAverageChangePercent = snapshot.fiftyDayAverageChangePercent ?? 0
        twoHundredDayAverage = snapshot.twoHundredDayAverage
        twoHundredDayAverageChange = snapshot.twoHundredDayAverageChange
        twoHundredDayAverageChangePercent = snapshot.twoHundredDayAverageChangePercent
        marketCap = Int64(snapshot.marketCap ?? 0)
        forwardPE = snapshot.forwardPE ?? 0
        priceToBook = snapshot.priceToBook ?? 0
        averageAnalystRating = snapshot.averageAnalystRating
        priceHint = Int32(snapshot.priceHint)
        postMarketChangePercent = snapshot.postMarketChangePercent ?? 0
        postMarketTime = Int32(snapshot.postMarketTime ?? 0)
        postMarketPrice = snapshot.postMarketPrice ?? 0
        postMarketChange = snapshot.postMarketChange ?? 0
        regularMarketTime = Int32(snapshot.regularMarketTime)
        regularMarketDayRange = snapshot.regularMarketDayRange

        regularMarketVolume = Int64(snapshot.regularMarketVolume)
        regularMarketPreviousClose = snapshot.regularMarketPreviousClose
        bidSize = Int32(snapshot.bidSize ?? 0)
        askSize = Int32(snapshot.askSize ?? 0)
        fullExchangeName = snapshot.fullExchangeName
        financialCurrency = snapshot.financialCurrency
        regularMarketOpen = snapshot.regularMarketOpen
        averageDailyVolume3Month = Int64(snapshot.averageDailyVolume3Month)
        averageDailyVolume10Day = Int64(snapshot.averageDailyVolume10Day)
        fiftyTwoWeekLowChange = snapshot.fiftyTwoWeekLowChange
        fiftyTwoWeekRange = snapshot.fiftyTwoWeekRange
        fiftyTwoWeekHighChange = snapshot.fiftyTwoWeekHighChange
        fiftyTwoWeekHighChangePercent = snapshot.fiftyTwoWeekHighChangePercent
        fiftyTwoWeekLow = snapshot.fiftyTwoWeekLow
        fiftyTwoWeekHigh = snapshot.fiftyTwoWeekHigh

        // Crypto Stuff
        circulatingSupply = Int64(snapshot.circulatingSupply ?? 0)
        lastMarket = snapshot.lastMarket
        volume24Hr = Int64(snapshot.volume24Hr ?? 0)
        volumeAllCurrencies = Int64(snapshot.volumeAllCurrencies ?? 0)
        fromCurrency = snapshot.fromCurrency
        toCurrency = snapshot.toCurrency
        coinMarketCapLink = snapshot.coinMarketCapLink
        startDate = Int32(snapshot.startDate ?? 0)
        coinImageURL = snapshot.coinImageURL
        logoURL = snapshot.logoURL
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
