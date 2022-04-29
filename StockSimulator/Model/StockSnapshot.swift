//
//  StockSnapshot.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/4/22.
//


import Foundation
import SwiftUI


// This is the data that is actually loaded from the API
// MARK: - QuoteSnapshot
struct QuoteSnapshot: Codable {
    let quoteResponse: QuoteResponse
}

// MARK: - QuoteResponse
struct QuoteResponse: Codable {
    let result: [StockSnapshot]
    let error: JSONNull?
}
struct StockSnapshot: Codable, Identifiable
{
//    enum quoteType: String, Decodable
//    {
//        case EQUITY, CRYPTOCURRENCY, CURRENCY
//    }
    var quoteType: String
    var displayName: String? // Apple
    var shortName, longName: String? 
    var currency: String // USD, etc
    var symbol: String // AAPL
    var language: String // en-US
    var ask: Double // 170.7
    var bid: Double // 170.6
    var market: String // us-market
    var regularMarketDayHigh: Double // 170.35
    var regularMarketDayLow: Double // 162.8
    var regularMarketPrice: Double // 170.33
    let regularMarketChange, regularMarketChangePercent: Double
    
    var id = UUID()
    
    
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
            return "No Name Found"
        }
    }

//    var id: Int = UUID().hashValue
    // these are added so that I can have the id property that is required for Identifiable. I need identifiable so that I can easily display in a stocks in a list.
    private enum CodingKeys: String, CodingKey {
        case quoteType, displayName, currency, symbol, language, ask, bid, market, regularMarketDayHigh, regularMarketDayLow, regularMarketPrice, shortName, longName, regularMarketChange, regularMarketChangePercent
    }



    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quoteType = try values.decode(String.self, forKey: .quoteType)

//        // Some stocks like DIS do not have a displayName, they have a longName and shortName instead...
        do {
            displayName = try values.decode(String.self, forKey: .displayName)
        }
        catch {
            displayName = nil
        }
//        displayName = try values.decode(String.self, forKey: .displayName)
        shortName = try values.decode(String.self, forKey: .shortName)
        longName = try values.decode(String.self, forKey: .longName)
        currency = try values.decode(String.self, forKey: .currency)
        symbol = try values.decode(String.self, forKey: .symbol)
        language = try values.decode(String.self, forKey: .language)
        ask = try values.decode(Double.self, forKey: .ask)
        bid = try values.decode(Double.self, forKey: .bid)
        market = try values.decode(String.self, forKey: .market)
        regularMarketDayHigh = try values.decode(Double.self, forKey: .regularMarketDayHigh)
        regularMarketDayLow = try values.decode(Double.self, forKey: .regularMarketDayLow)
        regularMarketPrice = try values.decode(Double.self, forKey: .regularMarketPrice)
        regularMarketChange = try values.decode(Double.self, forKey: .regularMarketChange)
        regularMarketChangePercent = try values.decode(Double.self, forKey: .regularMarketChangePercent)
        id = UUID()

    }

    init(stock: Stock)
    {
        self.quoteType = stock.quoteType ?? "Unknown"
        self.displayName = stock.wrappedDisplayName
        self.currency = stock.currency ?? "Unknown"
        self.symbol = stock.wrappedSymbol
        self.language = stock.language ?? "Unknown"
        self.ask = stock.ask
        self.bid = stock.bid
        self.market = stock.market ?? "Unknown"
        self.regularMarketDayHigh = stock.regularMarketDayHigh
        self.regularMarketDayLow = stock.regularMarketDayLow
        self.regularMarketPrice = stock.regularMarketPrice
        self.regularMarketChange = stock.regularMarketChange
        self.regularMarketChangePercent = stock.regularMarketChangePercent
        self.longName = stock.longName
        self.shortName = stock.shortName
        
    }


    // This is used to make up sample data to test...
    init()
    {
//    quoteType: "EQUITY", displayName: "Apple", currency: "USD", symbol: "AAPL", language: "en-US", ask: 168.24, bid: 168.41, market: "us_market", regularMarketDayHigh: 173.08, regularMarketDayLow: 168.04, regularMarketPrice: 168.64)
        // sample stock...
        self.quoteType = "EQUITY"
        self.displayName = "Apple"
        self.currency = "USD"
        self.symbol = "AAPL"
        self.language = "en-US"
        self.ask = 168.24
        self.bid = 168.41
        self.market = "us_market"
        self.regularMarketDayHigh = 173.08
        self.regularMarketDayLow = 168.04
        self.regularMarketPrice = 168.64
        self.regularMarketChange = 1.25
        self.regularMarketChangePercent = 0.03
        self.shortName = "Apple"
        self.longName = "Apple, Inc."

    }

}


// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
