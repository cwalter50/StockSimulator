//
//  PreviewProvider.swift
//  StockSimulator
//
//  Created by Christopher Walter on 5/18/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() { }
    

//    let homeVM = HomeViewModel()
    let stockVM = StocksViewModel()
    let chartVM = ChartViewModel()
    
    let dataController = DataController()
    
    let stat1 = StatisticModel(title: "Market Cap", value: "$12.5Bn", percentageChange: 25.34)
    let stat2 = StatisticModel(title: "Total Volume", value: "$1.23Tr")
    let stat3 = StatisticModel(title: "Portfolio Value", value: "$50.4K", percentageChange: -12.34)
    
    let earnings1 = EarningsModel(title: "3Q2021", actual: 2.1, estimate: 1.89, revenue: 83360000000, earnings: 20551000000)
    
    var sampleTransaction: Transaction {
        let t = Transaction(context: dataController.container.viewContext)
        t.stock = sampleStock
        t.account = sampleAccount
        t.id = UUID()
        t.buyDate = Date()
        t.purchasePrice = 100
        t.numShares = 10
        t.isClosed = false
        t.costBasis = t.purchasePrice * t.numShares
        t.eventType = "BUY"
        
        return t
    }
    var sampleAccount: Account {
        let account = Account(context: dataController.container.viewContext)
        account.cash = 10000
        
        return account
    }
    
    var sampleStock: Stock {
        let context = dataController.container.viewContext
        
        let stock = Stock(context: context)
        stock.updateValuesFromStockSnapshot(snapshot: StockSnapshot()) // this is sample Apple information
//        stock.symbol = "TEST"
//        stock.displayName = "ABC STOCK"
//        stock.regularMarketPrice = 21.34
//        stock.regularMarketChange = 1.05
//        stock.regularMarketChangePercent = 0.12
        
        return stock
    }
//    func sampleAccount() -> Account
//    {
//        let account = Account(context: dataController.container.viewContext)
//        account.cash = 10000
//
//        return account
//    }
    
    var sampleWatchlist: Watchlist {
        let context = dataController.container.viewContext
        let watchlist = Watchlist(context: context)
        watchlist.name = "Sample"
        
        let stock = Stock(context: context)
        stock.symbol = "TEST"
        stock.displayName = "ABC STOCK"
        stock.regularMarketPrice = 21.34
        
        watchlist.addToStocks(stock)
        
        let stock2 = Stock(context: context)
        stock2.symbol = "TEST2"
        stock2.displayName = "DEF STOCK"
        stock2.regularMarketPrice = 56.78
        
        watchlist.addToStocks(stock2)
        
        return watchlist
    }
    
//    func sampleWatchlist() -> Watchlist
//    {
//        let context = dataController.container.viewContext
//        let watchlist = Watchlist(context: context)
//        watchlist.name = "Sample"
//
//        let stock = Stock(context: context)
//        stock.symbol = "TEST"
//        stock.displayName = "ABC STOCK"
//        stock.regularMarketPrice = 21.34
//
//        watchlist.addToStocks(stock)
//
//        let stock2 = Stock(context: context)
//        stock2.symbol = "TEST2"
//        stock2.displayName = "DEF STOCK"
//        stock2.regularMarketPrice = 56.78
//
//        watchlist.addToStocks(stock2)
//
//        return watchlist
//    }
    
//    func sampleStock() -> Stock {
//        let context = dataController.container.viewContext
//
//        let stock = Stock(context: context)
//        stock.updateValuesFromStockSnapshot(snapshot: StockSnapshot()) // this is sample Apple information
////        stock.symbol = "TEST"
////        stock.displayName = "ABC STOCK"
////        stock.regularMarketPrice = 21.34
////        stock.regularMarketChange = 1.05
////        stock.regularMarketChangePercent = 0.12
//
//        return stock
//    }
    
    
    
    
//    Sample Market Summary Response:
//
//    {
//      "marketSummaryResponse": {
//        "error": null,
//        "result": [
//          {
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
//          },
//          {
//            "exchange": "DJI",
//            "exchangeDataDelayedBy": 0,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": 475857000000,
//            "fullExchangeName": "DJI",
//            "gmtOffSetMilliseconds": -14400000,
//            "language": "en-US",
//            "market": "us_market",
//            "marketState": "POST",
//            "priceHint": 2,
//            "quoteSourceName": "Delayed Quote",
//            "quoteType": "INDEX",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "439.58",
//              "raw": 439.58008
//            },
//            "regularMarketChangePercent": {
//              "fmt": "1.60%",
//              "raw": 1.5984213
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "27,500.89",
//              "raw": 27500.89
//            },
//            "regularMarketPrice": {
//              "fmt": "27,940.47",
//              "raw": 27940.47
//            },
//            "regularMarketTime": {
//              "fmt": "5:12PM EDT",
//              "raw": 1599685935
//            },
//            "shortName": "Dow 30",
//            "sourceInterval": 120,
//            "symbol": "^DJI",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "exchange": "NIM",
//            "exchangeDataDelayedBy": 0,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": 34612200000,
//            "fullExchangeName": "Nasdaq GIDS",
//            "gmtOffSetMilliseconds": -14400000,
//            "language": "en-US",
//            "market": "us_market",
//            "marketState": "POST",
//            "priceHint": 2,
//            "quoteSourceName": "Delayed Quote",
//            "quoteType": "INDEX",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "293.87",
//              "raw": 293.87402
//            },
//            "regularMarketChangePercent": {
//              "fmt": "2.71%",
//              "raw": 2.709093
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "10,847.70",
//              "raw": 10847.7
//            },
//            "regularMarketPrice": {
//              "fmt": "11,141.56",
//              "raw": 11141.564
//            },
//            "regularMarketTime": {
//              "fmt": "5:15PM EDT",
//              "raw": 1599686159
//            },
//            "shortName": "Nasdaq",
//            "sourceInterval": 15,
//            "symbol": "^IXIC",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "exchange": "WCB",
//            "exchangeDataDelayedBy": 20,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": 558279000000,
//            "fullExchangeName": "Chicago Options",
//            "gmtOffSetMilliseconds": -14400000,
//            "language": "en-US",
//            "market": "us_market",
//            "marketState": "POST",
//            "priceHint": 2,
//            "quoteType": "INDEX",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "21.89",
//              "raw": 21.888916
//            },
//            "regularMarketChangePercent": {
//              "fmt": "1.45%",
//              "raw": 1.4548081
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "1,504.59",
//              "raw": 1504.5913
//            },
//            "regularMarketPrice": {
//              "fmt": "1,526.48",
//              "raw": 1526.4802
//            },
//            "regularMarketTime": {
//              "fmt": "4:30PM EDT",
//              "raw": 1599683408
//            },
//            "shortName": "Russell 2000",
//            "sourceInterval": 15,
//            "symbol": "^RUT",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "contractSymbol": false,
//            "exchange": "NYM",
//            "exchangeDataDelayedBy": 30,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": 967003200000,
//            "fullExchangeName": "NY Mercantile",
//            "gmtOffSetMilliseconds": -14400000,
//            "headSymbol": true,
//            "headSymbolAsString": "CL=F",
//            "language": "en-US",
//            "market": "us24_market",
//            "marketState": "REGULAR",
//            "quoteType": "FUTURE",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "-0.22",
//              "raw": -0.2199974
//            },
//            "regularMarketChangePercent": {
//              "fmt": "-0.58%",
//              "raw": -0.5781798
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "38.05",
//              "raw": 38.05
//            },
//            "regularMarketPrice": {
//              "fmt": "37.83",
//              "raw": 37.83
//            },
//            "regularMarketTime": {
//              "fmt": "6:00PM EDT",
//              "raw": 1599688818
//            },
//            "shortName": "Crude Oil",
//            "sourceInterval": 30,
//            "symbol": "CL=F",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "contractSymbol": false,
//            "exchange": "CMX",
//            "exchangeDataDelayedBy": 30,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": 967608000000,
//            "fullExchangeName": "COMEX",
//            "gmtOffSetMilliseconds": -14400000,
//            "headSymbol": true,
//            "headSymbolAsString": "GC=F",
//            "language": "en-US",
//            "market": "us24_market",
//            "marketState": "REGULAR",
//            "quoteType": "FUTURE",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "-0.70",
//              "raw": -0.70007324
//            },
//            "regularMarketChangePercent": {
//              "fmt": "-0.04%",
//              "raw": -0.035811204
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "1,954.90",
//              "raw": 1954.9
//            },
//            "regularMarketPrice": {
//              "fmt": "1,954.20",
//              "raw": 1954.2
//            },
//            "regularMarketTime": {
//              "fmt": "6:00PM EDT",
//              "raw": 1599688818
//            },
//            "shortName": "Gold",
//            "sourceInterval": 15,
//            "symbol": "GC=F",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "contractSymbol": false,
//            "exchange": "CMX",
//            "exchangeDataDelayedBy": 30,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": 967608000000,
//            "fullExchangeName": "COMEX",
//            "gmtOffSetMilliseconds": -14400000,
//            "headSymbol": true,
//            "headSymbolAsString": "SI=F",
//            "language": "en-US",
//            "market": "us24_market",
//            "marketState": "REGULAR",
//            "quoteType": "FUTURE",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "0.10",
//              "raw": 0.10199928
//            },
//            "regularMarketChangePercent": {
//              "fmt": "0.38%",
//              "raw": 0.37661737
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "27.08",
//              "raw": 27.083
//            },
//            "regularMarketPrice": {
//              "fmt": "27.18",
//              "raw": 27.185
//            },
//            "regularMarketTime": {
//              "fmt": "6:00PM EDT",
//              "raw": 1599688819
//            },
//            "shortName": "Silver",
//            "sourceInterval": 15,
//            "symbol": "SI=F",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "currency": "USD",
//            "exchange": "CCY",
//            "exchangeDataDelayedBy": 0,
//            "exchangeTimezoneName": "Europe/London",
//            "exchangeTimezoneShortName": "BST",
//            "firstTradeDateMilliseconds": 1070236800000,
//            "fullExchangeName": "CCY",
//            "gmtOffSetMilliseconds": 3600000,
//            "language": "en-US",
//            "market": "ccy_market",
//            "marketState": "REGULAR",
//            "priceHint": 4,
//            "quoteSourceName": "Delayed Quote",
//            "quoteType": "CURRENCY",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "0.0032",
//              "raw": 0.0031987429
//            },
//            "regularMarketChangePercent": {
//              "fmt": "0.27%",
//              "raw": 0.2716066
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "1.1777",
//              "raw": 1.1777176
//            },
//            "regularMarketPrice": {
//              "fmt": "1.1809",
//              "raw": 1.1809163
//            },
//            "regularMarketTime": {
//              "fmt": "11:09PM BST",
//              "raw": 1599689363
//            },
//            "shortName": "EUR/USD",
//            "sourceInterval": 15,
//            "symbol": "EURUSD=X",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "exchange": "NYB",
//            "exchangeDataDelayedBy": 30,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": -252356400000,
//            "fullExchangeName": "NYBOT",
//            "gmtOffSetMilliseconds": -14400000,
//            "language": "en-US",
//            "longName": "Treasury Yield 10 Years",
//            "market": "us24_market",
//            "marketState": "REGULAR",
//            "priceHint": 4,
//            "quoteType": "INDEX",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "0.0190",
//              "raw": 0.018999994
//            },
//            "regularMarketChangePercent": {
//              "fmt": "2.78%",
//              "raw": 2.777777
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "0.6840",
//              "raw": 0.684
//            },
//            "regularMarketPrice": {
//              "fmt": "0.7030",
//              "raw": 0.703
//            },
//            "regularMarketTime": {
//              "fmt": "2:59PM EDT",
//              "raw": 1599677994
//            },
//            "shortName": "10-Yr Bond",
//            "sourceInterval": 30,
//            "symbol": "^TNX",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "exchange": "WCB",
//            "exchangeDataDelayedBy": 20,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": 631290600000,
//            "fullExchangeName": "Chicago Options",
//            "gmtOffSetMilliseconds": -14400000,
//            "language": "en-US",
//            "market": "us_market",
//            "marketState": "POST",
//            "priceHint": 2,
//            "quoteType": "INDEX",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "-2.65",
//              "raw": -2.6499996
//            },
//            "regularMarketChangePercent": {
//              "fmt": "-8.42%",
//              "raw": -8.423394
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "31.46",
//              "raw": 31.46
//            },
//            "regularMarketPrice": {
//              "fmt": "28.81",
//              "raw": 28.81
//            },
//            "regularMarketTime": {
//              "fmt": "4:14PM EDT",
//              "raw": 1599682489
//            },
//            "shortName": "Vix",
//            "sourceInterval": 15,
//            "symbol": "^VIX",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "currency": "USD",
//            "exchange": "CCY",
//            "exchangeDataDelayedBy": 0,
//            "exchangeTimezoneName": "Europe/London",
//            "exchangeTimezoneShortName": "BST",
//            "firstTradeDateMilliseconds": 1070236800000,
//            "fullExchangeName": "CCY",
//            "gmtOffSetMilliseconds": 3600000,
//            "language": "en-US",
//            "market": "ccy_market",
//            "marketState": "REGULAR",
//            "priceHint": 4,
//            "quoteSourceName": "Delayed Quote",
//            "quoteType": "CURRENCY",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "0.0029",
//              "raw": 0.0029371977
//            },
//            "regularMarketChangePercent": {
//              "fmt": "0.23%",
//              "raw": 0.22632584
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "1.2978",
//              "raw": 1.2977574
//            },
//            "regularMarketPrice": {
//              "fmt": "1.3007",
//              "raw": 1.3006946
//            },
//            "regularMarketTime": {
//              "fmt": "11:09PM BST",
//              "raw": 1599689363
//            },
//            "shortName": "GBP/USD",
//            "sourceInterval": 15,
//            "symbol": "GBPUSD=X",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "currency": "JPY",
//            "exchange": "CCY",
//            "exchangeDataDelayedBy": 0,
//            "exchangeTimezoneName": "Europe/London",
//            "exchangeTimezoneShortName": "BST",
//            "firstTradeDateMilliseconds": 846633600000,
//            "fullExchangeName": "CCY",
//            "gmtOffSetMilliseconds": 3600000,
//            "language": "en-US",
//            "market": "ccy_market",
//            "marketState": "REGULAR",
//            "priceHint": 4,
//            "quoteSourceName": "Delayed Quote",
//            "quoteType": "CURRENCY",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "0.2060",
//              "raw": 0.20599365
//            },
//            "regularMarketChangePercent": {
//              "fmt": "0.19%",
//              "raw": 0.19442166
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "105.9520",
//              "raw": 105.952
//            },
//            "regularMarketPrice": {
//              "fmt": "106.1580",
//              "raw": 106.158
//            },
//            "regularMarketTime": {
//              "fmt": "11:10PM BST",
//              "raw": 1599689420
//            },
//            "shortName": "USD/JPY",
//            "sourceInterval": 15,
//            "symbol": "JPY=X",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "exchange": "CCC",
//            "exchangeDataDelayedBy": 0,
//            "exchangeTimezoneName": "Europe/London",
//            "exchangeTimezoneShortName": "BST",
//            "firstTradeDateMilliseconds": 1410908400000,
//            "fullExchangeName": "CCC",
//            "gmtOffSetMilliseconds": 3600000,
//            "language": "en-US",
//            "market": "ccc_market",
//            "marketState": "REGULAR",
//            "quoteSourceName": "CryptoCompare",
//            "quoteType": "CRYPTOCURRENCY",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "141.08",
//              "raw": 141.07715
//            },
//            "regularMarketChangePercent": {
//              "fmt": "1.39%",
//              "raw": 1.3925841
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "10,130.60",
//              "raw": 10130.602
//            },
//            "regularMarketPrice": {
//              "fmt": "10,271.68",
//              "raw": 10271.679
//            },
//            "regularMarketTime": {
//              "fmt": "11:08PM BST",
//              "raw": 1599689310
//            },
//            "sourceInterval": 15,
//            "symbol": "BTC-USD",
//            "tradeable": true,
//            "triggerable": false
//          },
//          {
//            "exchange": "NIM",
//            "exchangeDataDelayedBy": 0,
//            "exchangeTimezoneName": "America/New_York",
//            "exchangeTimezoneShortName": "EDT",
//            "firstTradeDateMilliseconds": 1546266600000,
//            "fullExchangeName": "Nasdaq GIDS",
//            "gmtOffSetMilliseconds": -14400000,
//            "language": "en-US",
//            "market": "us_market",
//            "marketState": "POST",
//            "priceHint": 2,
//            "quoteSourceName": "Delayed Quote",
//            "quoteType": "INDEX",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "6.75",
//              "raw": 6.754898
//            },
//            "regularMarketChangePercent": {
//              "fmt": "3.11%",
//              "raw": 3.105599
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "217.51",
//              "raw": 217.507
//            },
//            "regularMarketPrice": {
//              "fmt": "224.26",
//              "raw": 224.262
//            },
//            "regularMarketTime": {
//              "fmt": "5:57PM EDT",
//              "raw": 1599688629
//            },
//            "shortName": "CMC Crypto 200",
//            "sourceInterval": 15,
//            "symbol": "^CMC200",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "exchange": "FGI",
//            "exchangeDataDelayedBy": 15,
//            "exchangeTimezoneName": "Europe/London",
//            "exchangeTimezoneShortName": "BST",
//            "firstTradeDateMilliseconds": 441964800000,
//            "fullExchangeName": "FTSE Index",
//            "gmtOffSetMilliseconds": 3600000,
//            "language": "en-US",
//            "market": "gb_market",
//            "marketState": "POSTPOST",
//            "priceHint": 2,
//            "quoteType": "INDEX",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "82.54",
//              "raw": 82.54004
//            },
//            "regularMarketChangePercent": {
//              "fmt": "1.39%",
//              "raw": 1.3918359
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "5,930.30",
//              "raw": 5930.3
//            },
//            "regularMarketPrice": {
//              "fmt": "6,012.84",
//              "raw": 6012.84
//            },
//            "regularMarketTime": {
//              "fmt": "4:35PM BST",
//              "raw": 1599665729
//            },
//            "shortName": "FTSE 100",
//            "sourceInterval": 15,
//            "symbol": "^FTSE",
//            "tradeable": false,
//            "triggerable": false
//          },
//          {
//            "exchange": "OSA",
//            "exchangeDataDelayedBy": 0,
//            "exchangeTimezoneName": "Asia/Tokyo",
//            "exchangeTimezoneShortName": "JST",
//            "firstTradeDateMilliseconds": -157420800000,
//            "fullExchangeName": "Osaka",
//            "gmtOffSetMilliseconds": 32400000,
//            "language": "en-US",
//            "market": "jp_market",
//            "marketState": "PREPRE",
//            "priceHint": 2,
//            "quoteType": "INDEX",
//            "region": "US",
//            "regularMarketChange": {
//              "fmt": "-241.59",
//              "raw": -241.5918
//            },
//            "regularMarketChangePercent": {
//              "fmt": "-1.04%",
//              "raw": -1.0380272
//            },
//            "regularMarketPreviousClose": {
//              "fmt": "23,274.13",
//              "raw": 23274.13
//            },
//            "regularMarketPrice": {
//              "fmt": "23,032.54",
//              "raw": 23032.54
//            },
//            "regularMarketTime": {
//              "fmt": "3:15PM JST",
//              "raw": 1599632102
//            },
//            "shortName": "Nikkei 225",
//            "sourceInterval": 20,
//            "symbol": "^N225",
//            "tradeable": false,
//            "triggerable": false
//          }
//        ]
//      }
//    }

}
