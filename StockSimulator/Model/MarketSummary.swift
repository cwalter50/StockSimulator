//
//  MarketSummary.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/13/22.
//

import Foundation
import SwiftUI

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)


// MARK: - Welcome
struct CompleteMarketSummary: Codable {
    let marketSummaryResponse: MarketSummaryResponse
}

// MARK: - MarketSummaryResponse
struct MarketSummaryResponse: Codable {
    let error: JSONNull?
    let result: [MarketSummary]
}

// MARK: - Result
struct MarketSummary: Codable {
    let exchange: String
    let exchangeDataDelayedBy: Int
    let exchangeTimezoneName: String?
    let exchangeTimezoneShortName: String?
//    let exchangeTimezoneName: ExchangeTimezoneName?
//    let exchangeTimezoneShortName: ExchangeTimezoneShortName?
    let firstTradeDateMilliseconds: Int
    let fullExchangeName: String
    let gmtOffSetMilliseconds: Int
    let language: Language
    let market, marketState: String
    let priceHint: Int?
    let quoteSourceName: String?
    let quoteType: String
    let region: Region
    let regularMarketChange, regularMarketChangePercent, regularMarketPreviousClose, regularMarketPrice: RegularMarket
    let regularMarketTime: RegularMarket
    let shortName: String?
    let sourceInterval: Int
    let symbol: String
    let tradeable, triggerable: Bool
    let contractSymbol, headSymbol: Bool?
    let headSymbolAsString, currency, longName: String?
//    var id = UUID()
    
    var wrappedName: String {
        if let name = shortName
        {
            return name
        } else {
            return fullExchangeName
        }
    }
    
    // this will be filled with Sample MarketData
    //            "exchange": "SNP",
    //            "exchangeDataDelayedBy": 0,
    //            "exchangeTimezoneName": "America/New_York",
    //            "exchangeTimezoneShortName": "EDT",
    //            "firstTradeDateMilliseconds": -1325583000000,
    //            "fullExchangeName": "SNP",
    //            "gmtOffSetMilliseconds": -14400000,
    //            "language": "en-US",
    //            "market": "us_market",
    //            "marketState": "POST",
    //            "priceHint": 2,
    //            "quoteSourceName": "Delayed Quote",
    //            "quoteType": "INDEX",
    //            "region": "US",
    //            "regularMarketChange": {
    //              "fmt": "67.12",
    //              "raw": 67.11987
    //            },
    //            "regularMarketChangePercent": {
    //              "fmt": "2.01%",
    //              "raw": 2.0144987
    //            },
    //            "regularMarketPreviousClose": {
    //              "fmt": "3,331.84",
    //              "raw": 3331.84
    //            },
    //            "regularMarketPrice": {
    //              "fmt": "3,398.96",
    //              "raw": 3398.96
    //            },
    //            "regularMarketTime": {
    //              "fmt": "5:12PM EDT",
    //              "raw": 1599685935
    //            },
    //            "shortName": "S&P 500",
    //            "sourceInterval": 15,
    //            "symbol": "^GSPC",
    //            "tradeable": false,
    //            "triggerable": false
    init()
    {
        exchange = "SNP"
        exchangeDataDelayedBy = 0
        exchangeTimezoneName = "America/New_York"
        exchangeTimezoneShortName = "EDT"
        firstTradeDateMilliseconds = -1325583000000
        fullExchangeName = "SNP"
        gmtOffSetMilliseconds = -14400000
        language = Language.enUS
        market = "us_market"
        marketState = "POST"
        priceHint = 2
        quoteSourceName = "Delayed Quote"
        quoteType = "INDEX"
        region = Region.us
        regularMarketChange = RegularMarket(fmt: "67.12", raw: 67.11987)
        regularMarketChangePercent = RegularMarket(fmt: "2.01%", raw: 2.0144987)
        regularMarketPreviousClose = RegularMarket(fmt: "3,331.84", raw: 3331.84)
        regularMarketPrice = RegularMarket(fmt: "3,398.96", raw: 3398.96)
        regularMarketTime = RegularMarket(fmt: "5:12PM EDT", raw: 1599685935)
        shortName = "S&P 500"
        sourceInterval = 15
        symbol = "^GSPC"
        tradeable = false
        triggerable = false
        contractSymbol = false
        headSymbol = false
        headSymbolAsString = ""
        currency = ""
        longName = ""
//        id = UUID()
    }
    
    
//    var id = UUID().uuidString
    
    
//    init(from decoder:Decoder) throws {
//        id = UUID()
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            exchange = try values.decode(String.self, forKey: .exchange)
//            exchangeDataDelayedBy = try values.decode(Int.self, forKey: .exchangeDataDelayedBy)
//            exchangeTimezoneName = try? values.decode(String.self, forKey: .exchangeTimezoneName)
//            exchangeTimezoneShortName = try? values.decode(String.self, forKey: .exchangeTimezoneShortName)
//            firstTradeDateMilliseconds = try values.decode(Int.self, forKey: .firstTradeDateMilliseconds)
//            fullExchangeName = try values.decode(String.self, forKey: .fullExchangeName)
//            gmtOffSetMilliseconds = try values.decode(Int.self, forKey: .gmtOffSetMilliseconds)
//            language = try values.decode(Language.self, forKey: .language)
//            market = try values.decode(String.self, forKey: .market)
//            marketState = try values.decode(String.self, forKey: .marketState)
//            priceHint = try values.decode(Int.self, forKey: .priceHint)
//            quoteSourceName = try? values.decode(String.self, forKey: .quoteSourceName)
//            quoteType = try values.decode(String.self, forKey: .quoteType)
//            region = try values.decode(Region.self, forKey: .region)
//            regularMarketChange = try values.decode(RegularMarket.self, forKey: .regularMarketChange)
//            regularMarketChangePercent = try values.decode(RegularMarket.self, forKey: .regularMarketChangePercent)
//            regularMarketPreviousClose = try values.decode(RegularMarket.self, forKey: .regularMarketPreviousClose)
//            regularMarketPrice = try values.decode(RegularMarket.self, forKey: .regularMarketPrice)
//            regularMarketTime = try values.decode(RegularMarket.self, forKey: .regularMarketTime)
//            shortName = try? values.decode(String.self, forKey: .shortName)
//            sourceInterval = try values.decode(Int.self, forKey: .sourceInterval)
//            symbol = try values.decode(String.self, forKey: .symbol)
//            tradeable = try values.decode(Bool.self, forKey: .tradeable)
//            triggerable = try values.decode(Bool.self, forKey: .triggerable)
//            contractSymbol = try? values.decode(Bool.self, forKey: .contractSymbol)
//            headSymbol = try? values.decode(Bool.self, forKey: .headSymbol)
//            headSymbolAsString = try? values.decode(String.self, forKey: .headSymbolAsString)
//            currency = try? values.decode(String.self, forKey: .currency)
//            longName = try? values.decode(String.self, forKey: .longName)
//    }

}

enum ExchangeTimezoneName: String, Codable {
    case americaNewYork = "America/New_York"
    case asiaTokyo = "Asia/Tokyo"
    case europeLondon = "Europe/London"
}

enum ExchangeTimezoneShortName: String, Codable {
    case bst = "BST"
    case edt = "EDT"
    case jst = "JST"
}

enum Language: String, Codable {
    case enUS = "en-US"
}

enum Region: String, Codable {
    case us = "US"
}

// MARK: - RegularMarket
struct RegularMarket: Codable {
    let fmt: String
    let raw: Double
}

// MARK: - Encode/decode helpers

class JSONNull: Codable{
//class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

//    public var hashValue: Int {
//        return 0
//    }

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
