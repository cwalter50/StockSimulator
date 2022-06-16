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
//    var id = UUID().uuidString
    
    
//    init(from decoder:Decoder) throws {
//
//
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        exchange = try values.decode(String.self, forKey: .quoteType)
//
//
//
//        quoteType = try values.decode(String.self, forKey: .quoteType)
//
//
//
//        shortName = try values.decode(String.self, forKey: .shortName)
//        longName = try values.decode(String.self, forKey: .longName)
//        currency = try values.decode(String.self, forKey: .currency)
//        symbol = try values.decode(String.self, forKey: .symbol)
//        language = try values.decode(String.self, forKey: .language)
//        ask = try values.decode(Double.self, forKey: .ask)
//        bid = try values.decode(Double.self, forKey: .bid)
//        market = try values.decode(String.self, forKey: .market)
//        regularMarketDayHigh = try values.decode(Double.self, forKey: .regularMarketDayHigh)
//        regularMarketDayLow = try values.decode(Double.self, forKey: .regularMarketDayLow)
//        regularMarketPrice = try values.decode(Double.self, forKey: .regularMarketPrice)
//        regularMarketChange = try values.decode(Double.self, forKey: .regularMarketChange)
//        regularMarketChangePercent = try values.decode(Double.self, forKey: .regularMarketChangePercent)
//        id = UUID()
//
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
