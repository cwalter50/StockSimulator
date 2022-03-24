//
//  ChartData.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/22/22.
//

import Foundation



struct MetaData: Codable {
    var chartPreviousClose: Double
    var currency: String
    
    var dataGranularity: String
    var exchangeName: String
    var exchangeTimezoneName: String
    var firstTradeDate: Double
    var gmtoffset: Int
    var instrumentType: String
    var priceHint: Int
    var range: String
    var regularMarketPrice: Double
    var regularMarketTime: Double
    var symbol: String
    var timezone: String
    var validRanges: [String]
    
    var currentTradingPeriod: CurrentTradingPeriod?
    
//    var post: CurrentTradingPeriod?
//    var pre: CurrentTradingPeriod?
//    var regular: CurrentTradingPeriod?
    
    init()
    {
        chartPreviousClose = 0
        currency = "USD"
        
        dataGranularity = "1d"
        exchangeName = "NY"
        exchangeTimezoneName = "GMT"
        firstTradeDate = 0
        gmtoffset = 0
        instrumentType = ""
        priceHint = 2
        range = "1m"
        regularMarketPrice = 0
        regularMarketTime = 0
        symbol = "AAPL"
        timezone = "GMT"
        validRanges = []
        
//        post = CurrentTradingPeriod(end: 0, gmtoffset: 0, start: 0, timezone: "GMT")
//        pre = CurrentTradingPeriod(end: 0, gmtoffset: 0, start: 0, timezone: "GMT")
//        regular = CurrentTradingPeriod(end: 0, gmtoffset: 0, start: 0, timezone: "GMT")
    }
}

struct ChartData: Codable {
    
    var adjclose: [Double]
    var close: [Double]
    var high: [Double]
    var low: [Double]
    var open: [Double]
    var volume: [Int]
    var timestamp: [Int]
    
    var metaData: MetaData?
    
    
    
    init()
    {
        adjclose = []
        close = []
        high = []
        low = []
        open = []
        volume = []
        timestamp = []
        
        metaData = MetaData()
        
        
    }
    init(results: [String: Any])
    {
        self.init()
        
        if let chart = results["chart"] as? [String:Any], let result = chart["result"] as? [[String:Any]]
        {
            if result.count > 0
            {
//                print(result[0])
                
                self.timestamp = result[0]["timestamp"] as? [Int] ?? [Int]()
//                print(timestamp)
                
                if let indicators = result[0]["indicators"] as? [String: Any], let quote = indicators["quote"] as? [[String: Any]], let adjClose2 = indicators["adjclose"] as? [[String: Any]] {
                    
                    if quote.count > 0
                    {
                        self.close = quote[0]["close"] as? [Double] ?? [Double]()
//                        print(close)
                        self.open = quote[0]["open"] as? [Double] ?? [Double]()
//                        print(open)
                        self.low = quote[0]["low"] as? [Double] ?? [Double]()
//                        print(low)
                        self.high = quote[0]["high"] as? [Double] ?? [Double]()
//                        print(high)
                        self.volume = quote[0]["volume"] as? [Int] ?? [Int]()
//                        print(volume)
                    }
                    
                    if adjClose2.count > 0
                    {
                        self.adjclose = adjClose2[0]["adjclose"] as? [Double] ?? [Double]()
//                        print(adjclose)
                    }
                    
                }
                if let meta = result[0]["meta"] as? [String:Any] {
                    do {
                        let json = try JSONSerialization.data(withJSONObject: meta)
                        metaData = try JSONDecoder().decode(MetaData.self, from: json)
    
//                        print(metaData)
    
    
                    } catch {
                        print(error)
                    }
                }

                
                
            }

        }
        else {
            print("Error parsing the data")
            
        }

    }
    
    
    
}


struct CurrentTradingPeriod: Codable {
    var post: TimeData
    var pre: TimeData
    var regular: TimeData
    
    struct TimeData: Codable
    {
        var end: Double
        var gmtoffset: Int
        var start: Double
        var timezone: String
    }
}

//struct ChartParent: Codable {
//    var chartResponse: ChartResponse
//}
//
//struct ChartResponse: Codable {
//    var error: ChartError?
//    var result: ChartResult?
//}
//
//struct ChartError: Codable {
//    var lang: String?
//    var description: String?
//    var message: String?
//    var code: Int
//}
//
//struct ChartResult: Codable {
//    var chartIndicators: ChartIndicators?
//    var chartMeta: ChartMeta?
//}


