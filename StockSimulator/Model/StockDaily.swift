//
//  StockDaily.swift
//  APIApp
//
//  Created by Christopher Walter on 4/10/20.
//  Copyright © 2020 DocsApps. All rights reserved.
//
import Foundation

// This is used for alphavantage. No longer in use, now that I am using yahoo finance.

class StockDaily: CustomStringConvertible
{
    
    
    
    // JSON data looks like this...
    /*
    "2019-11-15" =     {
        "1. open" = "263.6800";
        "2. high" = "265.7800";
        "3. low" = "263.0100";
        "4. close" = "265.7600";
        "5. volume" = 25093666;
    };
 */
    var symbol: String
    var date: String
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var volume: Int
    
    
    var description: String { // this is like the toString Method in java
//        return "Symbol: \(symbol)\nDate: \(date)\nOpen: \(open)\nHigh: \(high)\nLow: \(low)\nClose: \(close)\nVolume: \(volume)"
        return "Open: \(open)\nHigh: \(high)\nLow: \(low)\nClose: \(close)\nVolume: \(volume)"
    }
    
    init(data: [String: Any], date: String, symbol: String)
    {
        self.open = Double(data["1. open"] as? String ?? "0") ?? 0
        self.high = Double(data["2. high"] as? String ?? "0") ?? 0
        self.low = Double(data["3. low"] as? String ?? "0") ?? 0
        self.close = Double(data["4. close"] as? String ?? "0") ?? 0
        self.volume = Int(data["5. volume"] as? String ?? "0") ?? 0
        self.date = date
        self.symbol = symbol
    }
}
