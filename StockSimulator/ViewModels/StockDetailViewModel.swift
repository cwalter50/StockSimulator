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
    @Published var stock: Stock
    
    @Published var overviewStatistics: [StatisticModel] = []
    
    @Published var stockSnapshot: StockSnapshot
    

    init(stock: Stock)
    {

        self.stock = stock
        stockSnapshot = StockSnapshot(stock: stock)
        loadOverviewStats()
        
    }
    
    func loadOverviewStats()
    {
        if stockSnapshot.quoteType == "CRYPTOCURRENCY"
        {
            loadCryptoStats()
        }
        else {
            loadStockStats()
        }
        
    }
    
    private func loadStockStats()
    {

        let regularMarketPrice = stockSnapshot.regularMarketPrice.asCurrencyWith6Decimals()
        let priceStat = StatisticModel(title: "Price", value: regularMarketPrice)
        let previousCloseStat = StatisticModel(title: "Previous Close", value: stock.regularMarketPreviousClose.asCurrencyWith6Decimals())
        let marketCap = Double(stock.marketCap).formattedWithAbbreviations()
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap)
        let open = stock.regularMarketOpen.asCurrencyWith6Decimals()
        let openStat = StatisticModel(title: "Open", value: open)
        let avgVolume3Month = Double(stock.averageDailyVolume3Month).formattedWithAbbreviations()
        let avgVolume3MonthStat = StatisticModel(title: "Average Volume 3 Months", value: avgVolume3Month)
        let avgVolume10Day = Double(stock.averageDailyVolume10Day).formattedWithAbbreviations()
        let avgVolume10DayStat = StatisticModel(title: "Average Volume 10 Day", value: avgVolume10Day)
        let volume = Double(stock.regularMarketVolume).formattedWithAbbreviations()
        let volumeStat = StatisticModel(title: "Regular Market Volume", value: volume)
        let bid = stock.bid.asCurrencyWith6Decimals()
        let bidStat = StatisticModel(title: "Bid", value: bid)
        let ask = stock.ask.asCurrencyWith6Decimals()
        let askStat = StatisticModel(title: "Ask", value: ask)
        let shares = Double(stock.sharesOutstanding).formattedWithAbbreviations()
        let sharesOutstanding = StatisticModel(title: "Shares Outstanding", value: shares)
        let fiftyTwoWeekRange = StatisticModel(title: "FiftyTwo week range", value: stock.fiftyTwoWeekRange ?? "n/a")
        let averageAnalystRating = StatisticModel(title: "Average Analyst Rating", value: stock.averageAnalystRating ?? "n/a")
        let peratio = stock.trailingPE.asNumberString()
        let peStat = StatisticModel(title: "P/E", value: peratio)
        let forwardPeStat = StatisticModel(title: "Forward P/E", value: stock.forwardPE.asNumberString())
        let eps = stock.epsTrailingTwelveMonths.asNumberString()
        let epsStat = StatisticModel(title: "EPS", value: eps)
        let dayHighStat = StatisticModel(title: "Day High", value: stockSnapshot.regularMarketDayHigh.asCurrencyWith6Decimals())
        let dayLowStat = StatisticModel(title: "Day Low", value: stockSnapshot.regularMarketDayLow.asCurrencyWith6Decimals())
        let fiftyDayAvgStat = StatisticModel(title: "50 Day Average", value: stock.fiftyDayAverage.asCurrencyWith2Decimals())
        let fiftyDayAvgChangeStat = StatisticModel(title: "50 Day Average Change", value: stock.fiftyDayAverageChange.asCurrencyWith2Decimals(), percentageChange: stock.fiftyDayAverageChange)
        let twoHundredDayAvgStat = StatisticModel(title: "200 Day Average", value: stock.twoHundredDayAverage.asCurrencyWith2Decimals())
        let twoHundredDayAvgChangeStat = StatisticModel(title: "200 Day Average Change", value: stock.twoHundredDayAverageChange.asCurrencyWith2Decimals(), percentageChange: stock.twoHundredDayAverageChange)
    
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
    
    private func loadCryptoStats()
    {
        let previousCloseStat = StatisticModel(title: "Previous Close", value: stock.regularMarketPreviousClose.asCurrencyWith6Decimals())
        let dayRangeStat = StatisticModel(title: "24 HR Day Range", value: stock.regularMarketDayRange ?? "n/a")
        let marketCap = Double(stock.marketCap).formattedWithAbbreviations()
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap)
        
        let volume = Double(stock.volume24Hr).formattedWithAbbreviations()
        let volume24HrStat = StatisticModel(title: "24Hr Volume", value: volume)
        let volumeAll = Double(stock.volumeAllCurrencies).formattedWithAbbreviations()
        let volumeAllStat = StatisticModel(title: "Volume All Currencies", value: volumeAll)
        let avgVolume3Month = Double(stock.averageDailyVolume3Month).formattedWithAbbreviations()
        let avgVolume3MonthStat = StatisticModel(title: "Average Volume 3 Months", value: avgVolume3Month)
        let avgVolume10Day = Double(stock.averageDailyVolume10Day).formattedWithAbbreviations()
        let avgVolume10DayStat = StatisticModel(title: "Average Volume 10 Day", value: avgVolume10Day)
        let fiftyTwoWeekRangeStat = StatisticModel(title: "FiftyTwo Week Range", value: stock.fiftyTwoWeekRange ?? "n/a")
//        let highStat = StatisticModel(title: "Fifty-Two Week High", value: stock.fiftyTwoWeekHigh.asCurrencyWith6Decimals())
//        let lowStat = StatisticModel(title: "Fifty-Two Week Low", value: stock.fiftyTwoWeekLow.asCurrencyWith6Decimals())
        let fiftyDayAvgStat = StatisticModel(title: "50 Day Average", value: stock.fiftyDayAverage.asCurrencyWith2Decimals())
        let fiftyDayAvgChangeStat = StatisticModel(title: "50 Day Average Change", value: stock.fiftyDayAverageChange.asCurrencyWith2Decimals(), percentageChange: stock.fiftyDayAverageChange)
        let twoHundredDayAvgStat = StatisticModel(title: "200 Day Average", value: stock.twoHundredDayAverage.asCurrencyWith2Decimals())
        let twoHundredDayAvgChangeStat = StatisticModel(title: "200 Day Average Change", value: stock.twoHundredDayAverageChange.asCurrencyWith2Decimals(), percentageChange: stock.twoHundredDayAverageChange)
        let currencyStat = StatisticModel(title: "Currency", value: stock.currency ?? "n/a")
        
        var startDate = "n/a"
        if let startDateInt = stockSnapshot.startDate {
            startDate = Date(timeIntervalSince1970: Double(startDateInt)).asShortDateString()
        }
        let startDateStat = StatisticModel(title: "Start Date", value: startDate)
        
        overviewStatistics = [previousCloseStat, dayRangeStat, marketCapStat, volume24HrStat, volumeAllStat, avgVolume10DayStat, avgVolume3MonthStat, fiftyTwoWeekRangeStat, fiftyDayAvgStat, fiftyDayAvgChangeStat, twoHundredDayAvgStat, twoHundredDayAvgChangeStat, currencyStat, startDateStat]
    }
    
    func reloadStockData()
    {
        APICaller.shared.getQuoteData(searchSymbols: "\(stock.wrappedSymbol.uppercased())") { connectionResult in
            switch connectionResult {
            case .success(let stockSnapshots):
                if let foundStock = stockSnapshots.first(where: { $0.symbol.uppercased() == self.stock.wrappedSymbol.uppercased()}) {
                    DispatchQueue.main.async {
                        self.stockSnapshot = foundStock
                        self.stock.updateValuesFromStockSnapshot(snapshot: foundStock)
                    }
                    
                    
                }
            case .chartSuccess(let chartData):
                print("found chartData, but we should not have \(chartData)")
            case .marketSummarySuccess(let array):
                print("found marketData, but we should not have \(array)")
            case .failure(let string):
                print("Error loading stock data for \(self.stock.wrappedSymbol): \(string)")
            }
        }
    }
}
