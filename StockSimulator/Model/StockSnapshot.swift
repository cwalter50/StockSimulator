//
//  StockSnapshot.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/4/22.
//


import Foundation
import SwiftUI


// This is the data that is actually loaded from the API

struct StockSnapshot: Codable, Identifiable
{
//    enum quoteType: String, Decodable
//    {
//        case EQUITY, CRYPTOCURRENCY, CURRENCY
//    }
    var quoteType: String
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
    var id = UUID()

//    var id: Int = UUID().hashValue
    // these are added so that I can have the id property that is required for Identifiable. I need identifiable so that I can easily display in a stocks in a list.
    private enum CodingKeys: String, CodingKey {
        case quoteType, displayName, currency, symbol, language, ask, bid, market, regularMarketDayHigh, regularMarketDayLow, regularMarketPrice
    }
    

    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quoteType = try values.decode(String.self, forKey: .quoteType)
        
        // Some stocks like DIS do not have a displayName, they have a longName and shortName instead...
        do {
            displayName = try values.decode(String.self, forKey: .displayName)
        }
        catch {
            displayName = "No Name Found"
        }
        
        
//        displayName = try values.decode(String.self, forKey: .displayName)
        currency = try values.decode(String.self, forKey: .currency)
        symbol = try values.decode(String.self, forKey: .symbol)
        language = try values.decode(String.self, forKey: .language)
        ask = try values.decode(Double.self, forKey: .ask)
        bid = try values.decode(Double.self, forKey: .bid)
        market = try values.decode(String.self, forKey: .market)
        regularMarketDayHigh = try values.decode(Double.self, forKey: .regularMarketDayHigh)
        regularMarketDayLow = try values.decode(Double.self, forKey: .regularMarketDayLow)
        regularMarketPrice = try values.decode(Double.self, forKey: .regularMarketPrice)
        id = UUID()
        
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
        
    }
    
}


// This is the Stock class that works with Alpha Vantage. It is not in use after I switched to yahoo finance.

//class Stock: CustomStringConvertible, ObservableObject
//{
//    @Published var symbol: String
//    @Published var lastRefreshed: String // format "2020-04-09"
//    @Published var dailyStats: [StockDaily]
//    @Published var price: Double
//
//
//
//    public var description: String { // this is like the toString Method in java
//        var dailyStat = ""
//        for stat in dailyStats
//        {
//            if stat.date == lastRefreshed
//            {
//                dailyStat = stat.description
//            }
//        }
//        return "Symbol: \(symbol)\nLastRefreshed: \(lastRefreshed)\n\(dailyStat)"
////        return "Symbol: \(symbol)\nLastRefreshed: \(lastRefreshed)\n"
//    }
//
//    // this will be used to test basic info in content view
//    init()
//    {
//        self.symbol = "TEST"
//        self.lastRefreshed = "2022-01-28"
//        dailyStats = [StockDaily]()
//        price = 100.00
//
//    }
//
//    init(data: [String: Any])
//    {
//        /*
//         Data will come in as JSON and look like this...
//        ["Time Series (Daily)": {
//             "2019-11-15" =     {
//                 "1. open" = "263.6800";
//                 "2. high" = "265.7800";
//                 "3. low" = "263.0100";
//                 "4. close" = "265.7600";
//                 "5. volume" = 25093666;
//             };
//         ... a bunch more dates.. Those dates will become the daily Stats
//
//         }, "Meta Data": {
//             "1. Information" = "Daily Prices (open, high, low, close) and Volumes";
//             "2. Symbol" = AAPL;
//             "3. Last Refreshed" = "2020-04-09";
//             "4. Output Size" = Compact;
//             "5. Time Zone" = "US/Eastern";
//         }]
//
//         */
//        let generalData = data["Meta Data"] as? [String: Any]
//        self.symbol = generalData?["2. Symbol"] as? String ?? "error"
//
//        self.lastRefreshed = generalData?["3. Last Refreshed"] as? String ?? "error"
//        // load daily stats....
//        self.dailyStats = [StockDaily]()
//        self.price = 0 // gets set accurately later
//        self.symbol = symbol.uppercased()
//        guard let allStats = data["Time Series (Daily)"] as? [String: [String: Any]] else {
//                print("not stock data")
//                return
//            }
//
//        for day in allStats
//        {
//            let date = day.key
//            let currentDayData = day.value
//            let dayStats = StockDaily(data: currentDayData, date: date, symbol: self.symbol)
//            self.dailyStats.append(dayStats)
//        }
//
//        for stat in dailyStats {
//            if stat.date == lastRefreshed
//            {
//                price = stat.close
//            }
//        }
//    }
//}

