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
    var ask: Double? // 170.7
    var bid: Double? // 170.6
    var market: String // us-market
    var regularMarketDayHigh: Double // 170.35
    var regularMarketDayLow: Double // 162.8
    var regularMarketPrice: Double // 170.33
    let regularMarketChange, regularMarketChangePercent: Double
    
    
    var dividendDate: Int? // 1652313600
    var tradeable: Bool // false
    let earningsTimestamp: Int? // 1659038400
    let trailingPE: Double? // 25.055285
    let trailingAnnualDividendRate, trailingAnnualDividendYield, epsTrailingTwelveMonths: Double? // 0.88, 0.005664628, 6.15
    let epsForward, epsCurrentYear, priceEpsCurrentYear: Double? // 6.51, 6.13, 25.13703
    let sharesOutstanding: Int? // 16185199616
    let bookValue, fiftyDayAverage, fiftyDayAverageChange, fiftyDayAverageChangePercent: Double? // 4.158, 143.2188, 10.871201, 0.07590624
    let twoHundredDayAverage, twoHundredDayAverageChange, twoHundredDayAverageChangePercent: Double // 158.59525, -4.505249, -0.028407214,
    let marketCap: Int? // 2493977460736
    let forwardPE, priceToBook: Double? // 23.669737, 37.05868
    
    let averageAnalystRating: String? // "1.9 - Buy"
    let priceHint: Int // 2
    let postMarketChangePercent: Double? // -0.103838
    let postMarketTime: Int? // 1658534393
    let postMarketPrice, postMarketChange: Double? // 153.93, -0.160004
    let regularMarketTime: Int // 1658520003
    let regularMarketDayRange: String // 153.4101 - 156.28
    let regularMarketVolume: Int // 66675408
    let regularMarketPreviousClose: Double // 155.35
    let bidSize, askSize: Int? // 11, 8
    let fullExchangeName, financialCurrency: String? // NasdaqGS, USD
    let regularMarketOpen: Double // 155.39
    let averageDailyVolume3Month, averageDailyVolume10Day: Int // 93032838, , 72702620
    let fiftyTwoWeekLowChange: Double // 25.050003
    let fiftyTwoWeekRange: String // "129.04 - 182.94"
    let fiftyTwoWeekHighChange, fiftyTwoWeekHighChangePercent, fiftyTwoWeekLow, fiftyTwoWeekHigh: Double // -28.850006,-0.15770201, 129.04, 182.94
    
    // added for Crypto stuff
    let circulatingSupply: Int?
    let lastMarket: String?
    let volume24Hr, volumeAllCurrencies: Int?
    let fromCurrency, toCurrency: String?
    let coinMarketCapLink: String?
    let startDate: Int?
    let coinImageURL, logoURL: String?
    
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
        case quoteType, displayName, currency, symbol, language, ask, bid, market, regularMarketDayHigh, regularMarketDayLow, regularMarketPrice, shortName, longName, regularMarketChange, regularMarketChangePercent, dividendDate, tradeable, earningsTimestamp,trailingAnnualDividendRate, trailingPE, trailingAnnualDividendYield, epsTrailingTwelveMonths, epsForward, epsCurrentYear, priceEpsCurrentYear, sharesOutstanding, bookValue, fiftyDayAverage, fiftyDayAverageChange, fiftyDayAverageChangePercent, twoHundredDayAverage, twoHundredDayAverageChange, twoHundredDayAverageChangePercent, marketCap, forwardPE, priceToBook, averageAnalystRating, priceHint, postMarketChangePercent, postMarketTime, postMarketPrice, postMarketChange, regularMarketTime, regularMarketDayRange, regularMarketVolume, regularMarketPreviousClose, bidSize, askSize, fullExchangeName, financialCurrency, regularMarketOpen, averageDailyVolume3Month, averageDailyVolume10Day, fiftyTwoWeekLowChange, fiftyTwoWeekRange, fiftyTwoWeekHighChange, fiftyTwoWeekHighChangePercent, fiftyTwoWeekLow, fiftyTwoWeekHigh, circulatingSupply, lastMarket, volume24Hr, volumeAllCurrencies, fromCurrency, toCurrency, coinMarketCapLink, startDate, coinImageURL, logoURL
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
        shortName = try? values.decode(String.self, forKey: .shortName)
        longName = try? values.decode(String.self, forKey: .longName)
        currency = try values.decode(String.self, forKey: .currency)
        symbol = try values.decode(String.self, forKey: .symbol)
        language = try values.decode(String.self, forKey: .language)
        ask = try? values.decode(Double.self, forKey: .ask)
        bid = try? values.decode(Double.self, forKey: .bid)
        market = try values.decode(String.self, forKey: .market)
        regularMarketDayHigh = try values.decode(Double.self, forKey: .regularMarketDayHigh)
        regularMarketDayLow = try values.decode(Double.self, forKey: .regularMarketDayLow)
        regularMarketPrice = try values.decode(Double.self, forKey: .regularMarketPrice)
        regularMarketChange = try values.decode(Double.self, forKey: .regularMarketChange)
        regularMarketChangePercent = try values.decode(Double.self, forKey: .regularMarketChangePercent)
        
        dividendDate = try? values.decode(Int.self, forKey: .dividendDate)
        tradeable = try values.decode(Bool.self, forKey: .tradeable)
        earningsTimestamp = try? values.decode(Int.self, forKey: .earningsTimestamp)
        trailingAnnualDividendRate = try? values.decode(Double.self, forKey: .trailingAnnualDividendRate)
        trailingPE = try? values.decode(Double.self, forKey: .trailingPE)
        trailingAnnualDividendYield = try? values.decode(Double.self, forKey: .trailingAnnualDividendYield)
        epsTrailingTwelveMonths = try? values.decode(Double.self, forKey: .epsTrailingTwelveMonths)
        epsForward = try? values.decode(Double.self, forKey: .epsForward)
        epsCurrentYear = try? values.decode(Double.self, forKey: .epsCurrentYear)
        priceEpsCurrentYear = try? values.decode(Double.self, forKey: .priceEpsCurrentYear)
        sharesOutstanding = try? values.decode(Int.self, forKey: .sharesOutstanding)
        bookValue = try? values.decode(Double.self, forKey: .bookValue)
        fiftyDayAverage = try? values.decode(Double.self, forKey: .fiftyDayAverage)
        fiftyDayAverageChange = try? values.decode(Double.self, forKey: .fiftyDayAverageChange)
        fiftyDayAverageChangePercent = try? values.decode(Double.self, forKey: .fiftyDayAverageChangePercent)
        twoHundredDayAverage = try values.decode(Double.self, forKey: .twoHundredDayAverage)
        twoHundredDayAverageChange = try values.decode(Double.self, forKey: .twoHundredDayAverageChange)
        twoHundredDayAverageChangePercent = try values.decode(Double.self, forKey: .twoHundredDayAverageChangePercent)
        marketCap = try? values.decode(Int.self, forKey: .marketCap)
        forwardPE = try? values.decode(Double.self, forKey: .forwardPE)
        priceToBook = try? values.decode(Double.self, forKey: .priceToBook)
        
        averageAnalystRating = try? values.decode(String.self, forKey: .averageAnalystRating)
        priceHint = try values.decode(Int.self, forKey: .priceHint)
        postMarketChangePercent = try? values.decode(Double.self, forKey: .postMarketChangePercent)
        postMarketTime = try? values.decode(Int.self, forKey: .postMarketTime)
        postMarketPrice = try? values.decode(Double.self, forKey: .postMarketPrice)
        postMarketChange = try? values.decode(Double.self, forKey: .postMarketChange)
        regularMarketTime = try values.decode(Int.self, forKey: .regularMarketTime)
        regularMarketDayRange = try values.decode(String.self, forKey: .regularMarketDayRange)
        regularMarketVolume = try values.decode(Int.self, forKey: .regularMarketVolume)
        regularMarketPreviousClose = try values.decode(Double.self, forKey: .regularMarketPreviousClose)
        bidSize = try? values.decode(Int.self, forKey: .bidSize)
        askSize = try? values.decode(Int.self, forKey: .askSize)
        fullExchangeName = try? values.decode(String.self, forKey: .fullExchangeName)
        financialCurrency = try? values.decode(String.self, forKey: .financialCurrency)
        regularMarketOpen = try values.decode(Double.self, forKey: .regularMarketOpen)
        averageDailyVolume3Month = try values.decode(Int.self, forKey: .averageDailyVolume3Month)
        averageDailyVolume10Day = try values.decode(Int.self, forKey: .averageDailyVolume10Day)
        fiftyTwoWeekLowChange = try values.decode(Double.self, forKey: .fiftyTwoWeekLowChange)
        fiftyTwoWeekRange = try values.decode(String.self, forKey: .fiftyTwoWeekRange)
        fiftyTwoWeekHighChange = try values.decode(Double.self, forKey: .fiftyTwoWeekHighChange)
        fiftyTwoWeekHighChangePercent = try values.decode(Double.self, forKey: .fiftyTwoWeekHighChangePercent)
        fiftyTwoWeekLow = try values.decode(Double.self, forKey: .fiftyTwoWeekLow)
        fiftyTwoWeekHigh = try values.decode(Double.self, forKey: .fiftyTwoWeekHigh)
        
        circulatingSupply = try? values.decode(Int.self, forKey: .circulatingSupply)
        lastMarket = try? values.decode(String.self, forKey: .lastMarket)
        volume24Hr = try? values.decode(Int.self, forKey: .volume24Hr)
        volumeAllCurrencies = try? values.decode(Int.self, forKey: .volumeAllCurrencies)
        fromCurrency = try? values.decode(String.self, forKey: .fromCurrency)
        toCurrency = try? values.decode(String.self, forKey: .toCurrency)
        coinMarketCapLink = try? values.decode(String.self, forKey: .coinMarketCapLink)
        startDate = try? values.decode(Int.self, forKey: .startDate)
        coinImageURL = try? values.decode(String.self, forKey: .coinImageURL)
        logoURL = try? values.decode(String.self, forKey: .logoURL)
        
        
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
        
        tradeable = stock.tradeable
        earningsTimestamp = Int(stock.earningsTimestamp)
        trailingAnnualDividendRate = stock.trailingAnnualDividendRate
        trailingPE = stock.trailingPE
        trailingAnnualDividendYield = stock.trailingAnnualDividendYield
        epsTrailingTwelveMonths = stock.epsTrailingTwelveMonths
        epsForward = stock.epsForward
        epsCurrentYear = stock.epsCurrentYear
        priceEpsCurrentYear = stock.priceEpsCurrentYear
        sharesOutstanding = Int(stock.sharesOutstanding)
        bookValue = stock.bookValue
        fiftyDayAverage = stock.fiftyDayAverage
        fiftyDayAverageChange = stock.fiftyDayAverageChange
        fiftyDayAverageChangePercent = stock.fiftyDayAverageChangePercent
        twoHundredDayAverage = stock.twoHundredDayAverage
        twoHundredDayAverageChange = stock.twoHundredDayAverageChange
        twoHundredDayAverageChangePercent = stock.twoHundredDayAverageChangePercent
        marketCap = Int(stock.marketCap)
        forwardPE = stock.forwardPE
        priceToBook = stock.priceToBook
        averageAnalystRating = stock.averageAnalystRating
        priceHint = Int(stock.priceHint)
        postMarketChangePercent = stock.postMarketChangePercent
        postMarketTime = Int(stock.postMarketTime)
        postMarketPrice = stock.postMarketPrice
        postMarketChange = stock.postMarketChange
        regularMarketTime = Int(stock.regularMarketTime)
        regularMarketDayRange = stock.regularMarketDayRange ?? "n/a"
        regularMarketVolume = Int(stock.regularMarketVolume)
        regularMarketPreviousClose = stock.regularMarketPreviousClose
        bidSize = Int(stock.bidSize)
        askSize = Int(stock.askSize)
        fullExchangeName = stock.fullExchangeName
        financialCurrency = stock.financialCurrency
        regularMarketOpen = stock.regularMarketOpen
        averageDailyVolume3Month = Int(stock.averageDailyVolume3Month)
        averageDailyVolume10Day = Int(stock.averageDailyVolume10Day)
        fiftyTwoWeekLowChange = stock.fiftyTwoWeekLowChange
        fiftyTwoWeekRange = stock.fiftyTwoWeekRange ?? "n/a"
        fiftyTwoWeekHighChange = stock.fiftyTwoWeekHighChange
        fiftyTwoWeekHighChangePercent = stock.fiftyTwoWeekHighChangePercent
        fiftyTwoWeekLow = stock.fiftyTwoWeekLow
        fiftyTwoWeekHigh = stock.fiftyTwoWeekHigh
        dividendDate = Int(stock.dividendDate)
        
        circulatingSupply = Int(stock.circulatingSupply)
        lastMarket = stock.lastMarket
        volume24Hr = Int(stock.volume24Hr)
        volumeAllCurrencies = Int(stock.volumeAllCurrencies)
        fromCurrency = stock.fromCurrency
        toCurrency = stock.toCurrency
        coinMarketCapLink = stock.coinMarketCapLink
        startDate = Int(stock.startDate)
        coinImageURL = stock.coinImageURL
        logoURL = stock.logoURL
        
        
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
        
        dividendDate = 1652313600
        tradeable = false
        earningsTimestamp = 1659038400
        trailingAnnualDividendRate = 0.88
        trailingPE = 25.055285
        trailingAnnualDividendYield = 0.005664628
        epsTrailingTwelveMonths = 6.15
        
        epsForward = 6.51
        epsCurrentYear = 6.13
        priceEpsCurrentYear = 25.13703
        
        sharesOutstanding = 16185199616
        bookValue = 4.158
        fiftyDayAverage = 143.2188
        fiftyDayAverageChange = 10.871201
        fiftyDayAverageChangePercent = 0.07590624
        twoHundredDayAverage = 158.59525
        twoHundredDayAverageChange = -4.505249
        twoHundredDayAverageChangePercent = -0.028407214
        marketCap = 2493977460736
        forwardPE = 23.669737
        priceToBook = 37.05868
        
        averageAnalystRating = "1.9 - Buy"
        priceHint = 2
        postMarketChangePercent = -0.103838
        postMarketTime = 1658534393
        postMarketPrice = 153.93
        postMarketChange = -0.160004
        regularMarketTime = 1658520003
        regularMarketDayRange = "153.4101 - 156.28"
        regularMarketVolume = 66675408
        regularMarketPreviousClose = 155.35
        bidSize = 11
        askSize = 8
        fullExchangeName = "NasdaqGS"
        financialCurrency = "USD"
        regularMarketOpen = 155.39
        averageDailyVolume3Month = 93032838
        averageDailyVolume10Day = 72702620
        fiftyTwoWeekLowChange = 25.050003
        fiftyTwoWeekRange = "129.04 - 182.94"
        fiftyTwoWeekHighChange = -28.850006
        fiftyTwoWeekHighChangePercent = -0.15770201
        fiftyTwoWeekLow = 129.04
        fiftyTwoWeekHigh = 182.94
        
        circulatingSupply = 19105088
        lastMarket = "CoinMarketCap"
        volume24Hr = 25998045184
        volumeAllCurrencies = 25998045184
        fromCurrency = "BTC"
        toCurrency = "USD=X"
        coinMarketCapLink = "https://coinmarketcap.com/currencies/bitcoin"
        startDate = 1367107200
        coinImageURL = "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png"
        logoURL = "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png"
    }

}


// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//class JSONNull: Codable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
////    public var hashValue: Int {
////        return 0
////    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}

/* MARK: Sample Crypto Response */
/*
 "language": "en-US",
        "region": "US",
        "quoteType": "CRYPTOCURRENCY",
        "typeDisp": "Cryptocurrency",
        "quoteSourceName": "CoinMarketCap",
        "triggerable": true,
        "customPriceAlertConfidence": "HIGH",
        "currency": "USD",
        "firstTradeDateMilliseconds": 1410912000000,
        "fiftyTwoWeekLowChangePercent": 0.22418037,
        "fiftyTwoWeekRange": "17708.623 - 68789.625",
        "fiftyTwoWeekHighChange": -47111.08,
        "fiftyTwoWeekHighChangePercent": -0.6848573,
        "fiftyTwoWeekLow": 17708.623,
        "fiftyTwoWeekHigh": 68789.625,
        "fiftyDayAverage": 22011.48,
        "fiftyDayAverageChange": -332.93164,
        "fiftyDayAverageChangePercent": -0.015125363,
        "marketState": "REGULAR",
        "exchange": "CCC",
        "shortName": "Bitcoin USD",
        "messageBoardId": "finmb_BTC_CCC",
        "exchangeTimezoneName": "UTC",
        "exchangeTimezoneShortName": "UTC",
        "gmtOffSetMilliseconds": 0,
        "market": "ccc_market",
        "esgPopulated": false,
        "twoHundredDayAverage": 34544.03,
        "twoHundredDayAverageChange": -12865.482,
        "twoHundredDayAverageChangePercent": -0.3724372,
        "marketCap": 414170578944,
        "sourceInterval": 15,
        "exchangeDataDelayedBy": 0,
        "pageViewGrowthWeekly": 0.08143376,
        "tradeable": false,
        "priceHint": 2,
        "circulatingSupply": 19105088,
        "lastMarket": "CoinMarketCap",
        "volume24Hr": 25998045184,
        "volumeAllCurrencies": 25998045184,
        "fromCurrency": "BTC",
        "toCurrency": "USD=X",
        "coinMarketCapLink": "https://coinmarketcap.com/currencies/bitcoin",
        "regularMarketChange": 733.40234,
        "regularMarketChangePercent": 3.5015354,
        "regularMarketTime": 1658944560,
        "regularMarketPrice": 21678.549,
        "regularMarketDayHigh": 21687.785,
        "regularMarketDayRange": "21070.807 - 21687.785",
        "regularMarketDayLow": 21070.807,
        "regularMarketVolume": 25998045184,
        "regularMarketPreviousClose": 21227.094,
        "fullExchangeName": "CCC",
        "regularMarketOpen": 21227.094,
        "averageDailyVolume3Month": 32070365589,
        "averageDailyVolume10Day": 33143912705,
        "startDate": 1367107200,
        "coinImageUrl": "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
        "logoUrl": "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
        "fiftyTwoWeekLowChange": 3969.9258,
        "symbol": "BTC-USD"
 */

/* MARK: Sample Stock Response */
/*
 {
   "quoteResponse": {
     "result": [
       {
         "language": "en-US",
         "region": "US",
         "quoteType": "EQUITY",
         "typeDisp": "Equity",
         "quoteSourceName": "Nasdaq Real Time Price",
         "triggerable": true,
         "customPriceAlertConfidence": "HIGH",
         "currency": "USD",
         "firstTradeDateMilliseconds": 345479400000,
         "fiftyTwoWeekLowChangePercent": 0.1967607,
         "fiftyTwoWeekRange": "129.04 - 182.94",
         "fiftyTwoWeekHighChange": -28.51001,
         "fiftyTwoWeekHighChangePercent": -0.1558435,
         "fiftyTwoWeekLow": 129.04,
         "fiftyTwoWeekHigh": 182.94,
         "dividendDate": 1652313600,
         "earningsTimestamp": 1659038400,
         "earningsTimestampStart": 1659038400,
         "earningsTimestampEnd": 1659038400,
         "trailingAnnualDividendRate": 0.88,
         "trailingPE": 25.110567,
         "trailingAnnualDividendYield": 0.005804749,
         "epsTrailingTwelveMonths": 6.15,
         "epsForward": 6.5,
         "epsCurrentYear": 6.13,
         "priceEpsCurrentYear": 25.192493,
         "sharesOutstanding": 16185199616,
         "bookValue": 4.158,
         "fiftyDayAverage": 143.5286,
         "fiftyDayAverageChange": 10.901398,
         "fiftyDayAverageChangePercent": 0.07595279,
         "marketState": "REGULAR",
         "exchange": "NMS",
         "shortName": "Apple Inc.",
         "longName": "Apple Inc.",
         "messageBoardId": "finmb_24937",
         "exchangeTimezoneName": "America/New_York",
         "exchangeTimezoneShortName": "EDT",
         "gmtOffSetMilliseconds": -14400000,
         "market": "us_market",
         "esgPopulated": false,
         "twoHundredDayAverage": 158.69154,
         "twoHundredDayAverageChange": -4.261551,
         "twoHundredDayAverageChangePercent": -0.026854305,
         "marketCap": 2499480387584,
         "forwardPE": 23.758461,
         "priceToBook": 37.14045,
         "sourceInterval": 15,
         "exchangeDataDelayedBy": 0,
         "pageViewGrowthWeekly": -0.0075652064,
         "averageAnalystRating": "1.9 - Buy",
         "tradeable": false,
         "priceHint": 2,
         "regularMarketChange": 2.8299866,
         "regularMarketChangePercent": 1.8667457,
         "regularMarketTime": 1658944647,
         "regularMarketPrice": 154.43,
         "regularMarketDayHigh": 155.21,
         "regularMarketDayRange": "152.18 - 155.21",
         "regularMarketDayLow": 152.18,
         "regularMarketVolume": 35560129,
         "regularMarketPreviousClose": 151.6,
         "bid": 154.45,
         "ask": 154.47,
         "bidSize": 18,
         "askSize": 9,
         "fullExchangeName": "NasdaqGS",
         "financialCurrency": "USD",
         "regularMarketOpen": 152.58,
         "averageDailyVolume3Month": 91750000,
         "averageDailyVolume10Day": 69474260,
         "fiftyTwoWeekLowChange": 25.39,
         "displayName": "Apple",
         "symbol": "AAPL"
       },
 */

