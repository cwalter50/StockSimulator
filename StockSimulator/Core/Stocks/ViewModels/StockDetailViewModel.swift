//
//  StockDetailViewModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/27/22.
//

import Foundation
import SwiftUI
import Combine

class StockDetailViewModel: ObservableObject
{
    @Published var symbol: String = ""
//    @Published var stock: Stock? = nil
    
    @Published var overviewStatistics: [StatisticModel] = []
    
    @Published var stockSnapshot: StockSnapshot? = nil
    
    @Published var stockRating: Double = 0
    
    @Published var stockRecommendations: [RecommendedSymbol] = [] // this has an array of RecommendedSymbols
    
    @Published var quoteSummary: QuoteSummary? = nil
//    @Environment(\.managedObjectContext) var moc // CoreData
    
    @Published var earningsStatistics: [EarningsModel] = []

    init(stockSnapshot: StockSnapshot)
    {
        self.symbol = stockSnapshot.symbol
        
        self.stockSnapshot = stockSnapshot
        stockRecommendations = []
        loadOverviewStats()
        loadStockRecommendations()
        loadQuoteSummary(symbol: stockSnapshot.symbol)
    }
    
    init(symbol: String)
    {
        self.symbol = symbol
        reloadStockData(symbol: symbol)
        loadStockRecommendations()
        loadQuoteSummary(symbol: symbol)
        
    }
    
    func calculateStockRating() {
        
        guard let stockSnapshot = stockSnapshot else {
            return
        }
        
        guard let quoteSummary = quoteSummary, let keyStats = quoteSummary.defaultKeyStatistics else {
            return
        }
        


        // look at future earnings, PEG ratio, PE Ratio, 200 Day Average, 50 Day Average. Dividend Percent, average analyst rating
        
        var total = 0.0
        
        // Dividend Score will be worth 10 points If dividend 10% or higher, stock gets a 10, otherwise stock gets the dividend rate.
        let dividendRate = (stockSnapshot.trailingAnnualDividendYield ?? 0) * 100
        
        total += (dividendRate >= 10) ? 10 : dividendRate

        // average analyst rating
        // The weighting of the ratings is 1 for buy, 2 for outperform, 3 for hold, 4 for underperform and 5 for sell.
        
        
//        let epsForward = stockSnapshot.epsForward ?? 0
//        let eps = stockSnapshot.epsTrailingTwelveMonths ?? 0
//        print("epsForward: \(epsForward), eps: \(eps)")
//        let growth = epsForward - eps
//        total += growth
        
        
        stockRating = total
        
    }
    
    func loadStockRecommendations() {
        APICaller.shared.getReccomendationsBySymbol(symbol: self.symbol) { result in
            switch result {
            case .stockReccomendations(let array):
                var result : [RecommendedSymbol] = []
                for r in array {
                    result.append(contentsOf: r.recommendedSymbols)
                }
                DispatchQueue.main.async {
                    self.stockRecommendations = result
                }
            case .failure(let string):
                print("Error: " + string)
            default:
                print("Found unexpected result when loading stock reccomendations")
            }
        }
    }
    
    func loadOverviewStats()
    {
        guard let stockSnapshot = stockSnapshot else {
            return
        }
        if stockSnapshot.quoteType == "CRYPTOCURRENCY"
        {
            loadCryptoStats()
        }
        else {
            loadStockStats()
            calculateStockRating()
        }
        
    }
    
    private func loadStockStats()
    {
        guard let stockSnapshot = stockSnapshot else {
            return
        }

        let regularMarketPrice = stockSnapshot.regularMarketPrice.asCurrencyWith6Decimals()
        let priceStat = StatisticModel(title: "Price", value: regularMarketPrice)
        let previousCloseStat = StatisticModel(title: "Previous Close", value: stockSnapshot.regularMarketPreviousClose.asCurrencyWith6Decimals())
        let marketCap = Double(stockSnapshot.marketCap ?? 0).formattedWithAbbreviations()
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap)
        let open = stockSnapshot.regularMarketOpen.asCurrencyWith6Decimals()
        let openStat = StatisticModel(title: "Open", value: open)
        let avgVolume3Month = Double(stockSnapshot.averageDailyVolume3Month).formattedWithAbbreviations()
        let avgVolume3MonthStat = StatisticModel(title: "Average Volume 3 Months", value: avgVolume3Month)
        let avgVolume10Day = Double(stockSnapshot.averageDailyVolume10Day).formattedWithAbbreviations()
        let avgVolume10DayStat = StatisticModel(title: "Average Volume 10 Day", value: avgVolume10Day)
        let volume = Double(stockSnapshot.regularMarketVolume).formattedWithAbbreviations()
        let volumeStat = StatisticModel(title: "Regular Market Volume", value: volume)
        let bid = (stockSnapshot.bid ?? 0).asCurrencyWith6Decimals()
        let bidStat = StatisticModel(title: "Bid", value: bid)
        let ask = (stockSnapshot.ask ?? 0).asCurrencyWith6Decimals()
        let askStat = StatisticModel(title: "Ask", value: ask)
        let shares = Double(stockSnapshot.sharesOutstanding ?? 0).formattedWithAbbreviations()
        let sharesOutstanding = StatisticModel(title: "Shares Outstanding", value: shares)
        let fiftyTwoWeekRange = StatisticModel(title: "FiftyTwo week range", value: stockSnapshot.fiftyTwoWeekRange)
        let averageAnalystRating = StatisticModel(title: "Average Analyst Rating", value: stockSnapshot.averageAnalystRating ?? "n/a")
        let peratio = (stockSnapshot.trailingPE ?? 0).asNumberString()
        let peStat = StatisticModel(title: "P/E", value: peratio)
        let forwardPeStat = StatisticModel(title: "Forward P/E", value: (stockSnapshot.forwardPE ?? 0).asNumberString())
        let eps = (stockSnapshot.epsTrailingTwelveMonths ?? 0).asNumberString()
        let epsStat = StatisticModel(title: "EPS", value: eps)
        let dayHighStat = StatisticModel(title: "Day High", value: stockSnapshot.regularMarketDayHigh.asCurrencyWith6Decimals())
        let dayLowStat = StatisticModel(title: "Day Low", value: stockSnapshot.regularMarketDayLow.asCurrencyWith6Decimals())
        let fiftyDayAvgStat = StatisticModel(title: "50 Day Average", value: (stockSnapshot.fiftyDayAverage ?? 0).asCurrencyWith2Decimals())
        let fiftyDayAvgChangeStat = StatisticModel(title: "50 Day Average Change", value: (stockSnapshot.fiftyDayAverageChange ?? 0).asCurrencyWith2Decimals(), percentageChange: (stockSnapshot.fiftyDayAverageChangePercent ?? 0) * 100)
        let twoHundredDayAvgStat = StatisticModel(title: "200 Day Average", value: stockSnapshot.twoHundredDayAverage.asCurrencyWith2Decimals())
        let twoHundredDayAvgChangeStat = StatisticModel(title: "200 Day Average Change", value: stockSnapshot.twoHundredDayAverageChange.asCurrencyWith2Decimals(), percentageChange: stockSnapshot.twoHundredDayAverageChangePercent * 100)
    
        let dividend = stockSnapshot.trailingAnnualDividendRate?.asCurrencyWith6Decimals() ?? "$0.00"
        let dividendRate = ((stockSnapshot.trailingAnnualDividendYield ?? 0) * 100).asPercentString()
        let dividendStat = StatisticModel(title: "Dividend Yield (Rate)", value: "\(dividend)(\(dividendRate))")
        var dDate = "n/a"
        if let dividendDateInt = stockSnapshot.dividendDate {
            dDate = Date(timeIntervalSince1970: Double(dividendDateInt)).asShortDateString()
        }
        let divDateStat = StatisticModel(title: "Dividend Date", value: dDate)
        
        var earningsDate = "n/a"
        if let earnDateInt = stockSnapshot.earningsTimestamp {
            earningsDate = Date(timeIntervalSince1970: Double(earnDateInt)).asShortDateString()
        }
        let earningsDateStat = StatisticModel(title: "Earnings Date", value: earningsDate)

        overviewStatistics = [priceStat, previousCloseStat, dayHighStat, dayLowStat, marketCapStat, openStat, sharesOutstanding, volumeStat, avgVolume3MonthStat,avgVolume10DayStat, bidStat, askStat,  fiftyTwoWeekRange, peStat, forwardPeStat, epsStat, fiftyDayAvgStat,fiftyDayAvgChangeStat,twoHundredDayAvgStat,twoHundredDayAvgChangeStat,dividendStat, divDateStat,earningsDateStat, averageAnalystRating ]
        
    }
    
    private func loadEarningsStats() {
        
        guard let quoteSummary = quoteSummary, let earnings = quoteSummary.earnings else {
            print("no quote summary for \(symbol) found or no earnings found")
            return
        }
        
        earningsStatistics = earnings.earningsModels
    }
    
    private func loadCryptoStats()
    {
        guard let stockSnapshot = stockSnapshot else {
            return
        }
        let previousCloseStat = StatisticModel(title: "Previous Close", value: stockSnapshot.regularMarketPreviousClose.asCurrencyWith6Decimals())
        let dayRangeStat = StatisticModel(title: "24 HR Day Range", value: stockSnapshot.regularMarketDayRange)
        let marketCap = Double(stockSnapshot.marketCap ?? 0).formattedWithAbbreviations()
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap)
        
        let volume = Double(stockSnapshot.volume24Hr ?? 0).formattedWithAbbreviations()
        let volume24HrStat = StatisticModel(title: "24Hr Volume", value: volume)
        let volumeAll = Double(stockSnapshot.volumeAllCurrencies ?? 0).formattedWithAbbreviations()
        let volumeAllStat = StatisticModel(title: "Volume All Currencies", value: volumeAll)
        let avgVolume3Month = Double(stockSnapshot.averageDailyVolume3Month).formattedWithAbbreviations()
        let avgVolume3MonthStat = StatisticModel(title: "Average Volume 3 Months", value: avgVolume3Month)
        let avgVolume10Day = Double(stockSnapshot.averageDailyVolume10Day).formattedWithAbbreviations()
        let avgVolume10DayStat = StatisticModel(title: "Average Volume 10 Day", value: avgVolume10Day)
        let fiftyTwoWeekRangeStat = StatisticModel(title: "FiftyTwo Week Range", value: stockSnapshot.fiftyTwoWeekRange)
//        let highStat = StatisticModel(title: "Fifty-Two Week High", value: stock.fiftyTwoWeekHigh.asCurrencyWith6Decimals())
//        let lowStat = StatisticModel(title: "Fifty-Two Week Low", value: stock.fiftyTwoWeekLow.asCurrencyWith6Decimals())
        let fiftyDayAvgStat = StatisticModel(title: "50 Day Average", value: (stockSnapshot.fiftyDayAverage ?? 0).asCurrencyWith2Decimals())
        let fiftyDayAvgChangeStat = StatisticModel(title: "50 Day Average Change", value: (stockSnapshot.fiftyDayAverageChange ?? 0).asCurrencyWith2Decimals(), percentageChange: stockSnapshot.fiftyDayAverageChange)
        let twoHundredDayAvgStat = StatisticModel(title: "200 Day Average", value: stockSnapshot.twoHundredDayAverage.asCurrencyWith2Decimals())
        let twoHundredDayAvgChangeStat = StatisticModel(title: "200 Day Average Change", value: stockSnapshot.twoHundredDayAverageChange.asCurrencyWith2Decimals(), percentageChange: stockSnapshot.twoHundredDayAverageChange)
        let currencyStat = StatisticModel(title: "Currency", value: stockSnapshot.currency)
        
        var startDate = "n/a"
        if let startDateInt = stockSnapshot.startDate {
            startDate = Date(timeIntervalSince1970: Double(startDateInt)).asShortDateString()
        }
        let startDateStat = StatisticModel(title: "Start Date", value: startDate)
        
        overviewStatistics = [previousCloseStat, dayRangeStat, marketCapStat, volume24HrStat, volumeAllStat, avgVolume10DayStat, avgVolume3MonthStat, fiftyTwoWeekRangeStat, fiftyDayAvgStat, fiftyDayAvgChangeStat, twoHundredDayAvgStat, twoHundredDayAvgChangeStat, currencyStat, startDateStat]
    }
    
    func reloadStockData(symbol: String)
    {
        
        APICaller.shared.getQuoteData(searchSymbols: "\(symbol.uppercased())") { connectionResult in
            switch connectionResult {
            case .success(let stockSnapshots):
                if let foundStock = stockSnapshots.first(where: { $0.symbol.uppercased() == self.symbol.uppercased()}) {
                    DispatchQueue.main.async {
                        self.stockSnapshot = foundStock
                        self.loadOverviewStats()
                    }
                }
            case .failure(let string):
                print("Error loading stock data for \(self.symbol): \(string)")
            default:
                print("Found Unexpected response getting quoteData")
            }
            
            
        }
    }
    
    func loadQuoteSummary(symbol: String)
    {
        APICaller.shared.getQuoteSummary(symbol: symbol) { result in
            switch result {
            case .quoteSummarySuccess(let array):
//                print(array)
                if let data = array.first {
                    DispatchQueue.main.async {
                        self.quoteSummary = data
                        self.loadEarningsStats()
                        self.calculateStockRating()
                    }
                }
            case .failure(let string):
                print("Error loading QuoteSummary: \(string)")
            default:
                print("Unexpected result when loading a quote summary for \(symbol)")
            }
            
        }
    }
}
