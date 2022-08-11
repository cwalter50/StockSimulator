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
        chartPreviousClose = 164.85
        currency = "USD"
        dataGranularity = "1d"
        exchangeName = "NY"
        exchangeTimezoneName = "GMT"
        firstTradeDate = 345479400
        gmtoffset = -14400
        instrumentType = "EQUITY"
        priceHint = 2
        range = "1m"
        regularMarketPrice = 177.77
        regularMarketTime = 1648670404
        symbol = "AAPL"
        timezone = "GMT"
        validRanges = ["1d",
                       "5d",
                       "1mo",
                       "3mo",
                       "6mo",
                       "1y",
                       "2y",
                       "5y",
                       "10y",
                       "ytd",
                       "max"]
        
//        post = CurrentTradingPeriod(end: 0, gmtoffset: 0, start: 0, timezone: "GMT")
//        pre = CurrentTradingPeriod(end: 0, gmtoffset: 0, start: 0, timezone: "GMT")
//        regular = CurrentTradingPeriod(end: 0, gmtoffset: 0, start: 0, timezone: "GMT")
    }
}

struct ChartData: Codable {
    
    var adjclose: [Double?]
    var close: [Double?] // sometimes null comes through with the data
    var high: [Double?]
    var low: [Double?]
    var open: [Double?]
    var volume: [Int?]
    var timestamp: [Int]
    var events: Events?
    
    var wrappedClose: [Double] {
        var result = [Double]()
        for i in close {
            if let val = i
            {
                result.append(val)
            }
        }
        return result
    }
    
    var wrappedadjclose: [Double] {
        var result = [Double]()
        for i in adjclose {
            if let val = i
            {
                result.append(val)
            }
        }
        return result
    }
    
    var wrappedhigh: [Double] {
        var result = [Double]()
        for i in high {
            if let val = i
            {
                result.append(val)
            }
        }
        return result
    }
    
    var wrappedlow: [Double] {
        var result = [Double]()
        for i in low {
            if let val = i
            {
                result.append(val)
            }
        }
        return result
    }
    
    var wrappedopen: [Double] {
        var result = [Double]()
        for i in open {
            if let val = i
            {
                result.append(val)
            }
        }
        return result
    }
    
    var wrappedvolume: [Int] {
        var result = [Int]()
        for i in volume {
            if let val = i
            {
                result.append(val)
            }
        }
        return result
    }
    
    // this is a helper function for 
    func priceAtOpenOnDate(date: Int) -> Double?
    {
        if let location = timestamp.firstIndex(of: date) {
            return open[location]
        }
        else {
            return nil
        }
    }
    
    var metaData: MetaData?
    
    var errorMessage: String?
    
    // this is sample 1 month data for AAPL on 3/30/22 // this is mockData
    init()
    {
        print("init() called on chartData it is MockData")
        adjclose = [165.1199951171875,
                    163.1999969482422,
                    166.5599975585938,
                    166.2299957275391,
                    163.1699981689453,
                    159.3000030517578,
                    157.4400024414062,
                    162.9499969482422,
                    158.5200042724609,
                    154.7299957275391,
                    150.6199951171875,
                    155.0899963378906,
                    159.5899963378906,
                    160.6199951171875,
                    163.9799957275391,
                    165.3800048828125,
                    168.8200073242188,
                    170.2100067138672,
                    174.0700073242188,
                    174.7200012207031,
                    175.6000061035156,
                    178.9600067138672,
                    177.7700042724609]
        close = [165.1199951171875,
                 163.1999969482422,
                 166.5599975585938,
                 166.2299957275391,
                 163.1699981689453,
                 159.3000030517578,
                 157.4400024414062,
                 162.9499969482422,
                 158.5200042724609,
                 154.7299957275391,
                 150.6199951171875,
                 155.0899963378906,
                 159.5899963378906,
                 160.6199951171875,
                 163.9799957275391,
                 165.3800048828125,
                 168.8200073242188,
                 170.2100067138672,
                 174.0700073242188,
                 174.7200012207031,
                 175.6000061035156,
                 178.9600067138672,
                 177.7700042724609]
        high = [165.4199981689453,
                166.6000061035156,
                167.3600006103516,
                168.9100036621094,
                165.5500030517578,
                165.0200042724609,
                162.8800048828125,
                163.4100036621094,
                160.3899993896484,
                159.2799987792969,
                154.1199951171875,
                155.5700073242188,
                160,
                161,
                164.4799957275391,
                166.3500061035156,
                169.4199981689453,
                172.6399993896484,
                174.1399993896484,
                175.2799987792969,
                175.7299957275391,
                179.0099945068359,
                179.6100006103516]
        low = [162.4299926757812,
               161.9700012207031,
               162.9499969482422,
               165.5500030517578,
               162.1000061035156,
               159.0399932861328,
               155.8000030517578,
               159.4100036621094,
               155.9799957275391,
               154.5,
               150.1000061035156,
               150.3800048828125,
               154.4600067138672,
               157.6300048828125,
               159.7599945068359,
               163.0099945068359,
               164.9100036621094,
               167.6499938964844,
               170.2100067138672,
               172.75,
               172,
               176.3399963378906,
               176.6999969482422]
        open = [163.0599975585938,
                164.6999969482422,
                164.3899993896484,
                168.4700012207031,
                164.4900054931641,
                163.3600006103516,
                158.8200073242188,
                161.4799957275391,
                160.1999969482422,
                158.9299926757812,
                151.4499969482422,
                150.8999938964844,
                157.0500030517578,
                158.6100006103516,
                160.5099945068359,
                163.5099945068359,
                165.5099945068359,
                167.9900054931641,
                171.0599975585938,
                173.8800048828125,
                172.1699981689453,
                176.6900024414062,
                178.5500030517578]
        volume = [94869100,
                  83474400,
                  79724800,
                  76678400,
                  83737200,
                  96418800,
                  131148300,
                  91454900,
                  105342000,
                  96836300,
                  108732100,
                  92964300,
                  102300200,
                  75615400,
                  123351200,
                  95811400,
                  81532000,
                  98062700,
                  90131400,
                  80470700,
                  90371900,
                  100589400,
                  92633154]
        timestamp = [1646058600,
                     1646145000,
                     1646231400,
                     1646317800,
                     1646404200,
                     1646663400,
                     1646749800,
                     1646836200,
                     1646922600,
                     1647009000,
                     1647264600,
                     1647351000,
                     1647437400,
                     1647523800,
                     1647610200,
                     1647869400,
                     1647955800,
                     1648042200,
                     1648128600,
                     1648215000,
                     1648474200,
                     1648560600,
                     1648670404]
        
        metaData = MetaData()
        
        
    }
    
    init (emptyData: Bool)
    {
        print("init(emptyData) called on chartData")
        
        adjclose = []
        close = []
        high = []
        low = []
        open = []
        volume = []
        timestamp = []
        if emptyData == false {
            adjclose = [165.1199951171875,
                        163.1999969482422,
                        166.5599975585938,
                        166.2299957275391,
                        163.1699981689453,
                        159.3000030517578,
                        157.4400024414062,
                        162.9499969482422,
                        158.5200042724609,
                        154.7299957275391,
                        150.6199951171875,
                        155.0899963378906,
                        159.5899963378906,
                        160.6199951171875,
                        163.9799957275391,
                        165.3800048828125,
                        168.8200073242188,
                        170.2100067138672,
                        174.0700073242188,
                        174.7200012207031,
                        175.6000061035156,
                        178.9600067138672,
                        177.7700042724609]
            close = [165.1199951171875,
                     163.1999969482422,
                     166.5599975585938,
                     166.2299957275391,
                     163.1699981689453,
                     159.3000030517578,
                     157.4400024414062,
                     162.9499969482422,
                     158.5200042724609,
                     154.7299957275391,
                     150.6199951171875,
                     155.0899963378906,
                     159.5899963378906,
                     160.6199951171875,
                     163.9799957275391,
                     165.3800048828125,
                     168.8200073242188,
                     170.2100067138672,
                     174.0700073242188,
                     174.7200012207031,
                     175.6000061035156,
                     178.9600067138672,
                     177.7700042724609]
            high = [165.4199981689453,
                    166.6000061035156,
                    167.3600006103516,
                    168.9100036621094,
                    165.5500030517578,
                    165.0200042724609,
                    162.8800048828125,
                    163.4100036621094,
                    160.3899993896484,
                    159.2799987792969,
                    154.1199951171875,
                    155.5700073242188,
                    160,
                    161,
                    164.4799957275391,
                    166.3500061035156,
                    169.4199981689453,
                    172.6399993896484,
                    174.1399993896484,
                    175.2799987792969,
                    175.7299957275391,
                    179.0099945068359,
                    179.6100006103516]
            low = [162.4299926757812,
                   161.9700012207031,
                   162.9499969482422,
                   165.5500030517578,
                   162.1000061035156,
                   159.0399932861328,
                   155.8000030517578,
                   159.4100036621094,
                   155.9799957275391,
                   154.5,
                   150.1000061035156,
                   150.3800048828125,
                   154.4600067138672,
                   157.6300048828125,
                   159.7599945068359,
                   163.0099945068359,
                   164.9100036621094,
                   167.6499938964844,
                   170.2100067138672,
                   172.75,
                   172,
                   176.3399963378906,
                   176.6999969482422]
            open = [163.0599975585938,
                    164.6999969482422,
                    164.3899993896484,
                    168.4700012207031,
                    164.4900054931641,
                    163.3600006103516,
                    158.8200073242188,
                    161.4799957275391,
                    160.1999969482422,
                    158.9299926757812,
                    151.4499969482422,
                    150.8999938964844,
                    157.0500030517578,
                    158.6100006103516,
                    160.5099945068359,
                    163.5099945068359,
                    165.5099945068359,
                    167.9900054931641,
                    171.0599975585938,
                    173.8800048828125,
                    172.1699981689453,
                    176.6900024414062,
                    178.5500030517578]
            volume = [94869100,
                      83474400,
                      79724800,
                      76678400,
                      83737200,
                      96418800,
                      131148300,
                      91454900,
                      105342000,
                      96836300,
                      108732100,
                      92964300,
                      102300200,
                      75615400,
                      123351200,
                      95811400,
                      81532000,
                      98062700,
                      90131400,
                      80470700,
                      90371900,
                      100589400,
                      92633154]
            timestamp = [1646058600,
                         1646145000,
                         1646231400,
                         1646317800,
                         1646404200,
                         1646663400,
                         1646749800,
                         1646836200,
                         1646922600,
                         1647009000,
                         1647264600,
                         1647351000,
                         1647437400,
                         1647523800,
                         1647610200,
                         1647869400,
                         1647955800,
                         1648042200,
                         1648128600,
                         1648215000,
                         1648474200,
                         1648560600,
                         1648670404]
            
            metaData = MetaData()
        }
//        if emptyData == false
//        {
//            self.init()
//
//        }
//        else {
//            adjclose = []
//            close = []
//            high = []
//            low = []
//            open = []
//            volume = []
//            timestamp = []
//        }
        
    }
    
    init(results: [String: Any])
    {
        adjclose = []
        close = []
        high = []
        low = []
        open = []
        volume = []
        timestamp = []
        
        if let chart = results["chart"] as? [String:Any], let result = chart["result"] as? [[String:Any]]
        {
            if result.count > 0
            {
//                print(result[0])
                self.timestamp = result[0]["timestamp"] as? [Int] ?? [Int]()
//                print(timestamp)
                
                if let theEvents = result[0]["events"] as? [String:Any] {
//                    print(theEvents)
                    do {
                        let json = try JSONSerialization.data(withJSONObject: theEvents)
                        events = try JSONDecoder().decode(Events.self, from: json)
//                        print("Found events for Stock")
//                        print(events)
                    } catch {
                        print(error)
                    }
                }
                if let indicators = result[0]["indicators"] as? [String: Any], let quote = indicators["quote"] as? [[String: Any]] {
                    
//                    print(quote)
                    if quote.count > 0
                    {
//                        print("quote[0] is \(quote[0])")
                        self.close = quote[0]["close"] as? [Double?] ?? [1,nil,2]
//                        print(close)
                        self.open = quote[0]["open"] as? [Double?] ?? [Double]()
//                        print(open)
                        self.low = quote[0]["low"] as? [Double?] ?? [Double]()
//                        print(low)
                        self.high = quote[0]["high"] as? [Double?] ?? [Double]()
//                        print(high)
                        self.volume = quote[0]["volume"] as? [Int?] ?? [Int]()
//                        print(volume)
                    }
                    if let adjClose2 = indicators["adjclose"] as? [[String: Any]] {
                    
                        if adjClose2.count > 0
                        {
                            self.adjclose = adjClose2[0]["adjclose"] as? [Double] ?? [Double]()
    //                        print(adjclose)
                        }
                    }
                    
                }
                if let meta = result[0]["meta"] as? [String:Any] {
                    do {
                        let json = try JSONSerialization.data(withJSONObject: meta)
                        metaData = try JSONDecoder().decode(MetaData.self, from: json)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        else {
            errorMessage = results["message"] as? String ?? "Error Found Parsing ChartData"
            print(errorMessage ?? "Error")
            print(results)
            
        }


    }
    

    
    // MARK: - Events
    struct Events: Codable {
        let dividends: [String: Dividend]?
        let splits: [String: Split]?
    }

    // MARK: - Dividend
    struct Dividend: Codable {
        let amount: Double
        let date: Int
        
        var dateFormated: String {
            return Date(timeIntervalSince1970: TimeInterval(date)).asShortDateString()
        }
    }

    // MARK: - Split
    struct Split: Codable {
        let date, numerator, denominator: Int
        let splitRatio: String
        
        var dateFormated: String {
            return Date(timeIntervalSince1970: TimeInterval(date)).asShortDateString()
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

