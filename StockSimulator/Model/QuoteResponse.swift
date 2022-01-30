//
//  QuoteResponse.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/30/22.
//

import Foundation

struct QuoteResponse: Decodable
{
    var quoteResponse: Response

}

struct Response: Decodable
{
    var error: String
//    var result: [Investment]
}

struct Investment: Decodable
{
    enum quoteType: String, Decodable
    {
        case EQUITY, CRYPTOCURRENCY, CURRENCY
    }
    var displayName: String // Apple
    var currency: String // USD, etc
    var symbol: String // AAPL
    var language: String // en-US
    var ask: Double // 170.7
    var bid: Double // 170.6
    var market: String // us-market
    var regularMarketDayHigh: Double // 170.35
    var regularMarketDayLow: Double // 162.8
    var regularMarketPrice: Double // 170.33
    
}


