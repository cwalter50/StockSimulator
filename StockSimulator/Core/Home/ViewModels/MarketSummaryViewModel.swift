//
//  MarketSummaryViewModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 9/9/22.
//

import Foundation
import SwiftUI

class MarketSummaryViewModel: ObservableObject
{
    @Published var marketData: [MarketSummary] = []
    
    @Published var snpMarketStats: [StatisticModel] = [] // this will display S&P market highlights on homeview
    @Published var dowMarketStats: [StatisticModel] = [] // this will display dow market highlights on homeview
    @Published var nasdaqMarketStats: [StatisticModel] = [] // this will display nasdaq market highlights on homeview
    
    
    @Published var isLoading: Bool = false
    
    init() {
        loadMarketData()
    }
    
    func updateMarketData()
    {
        isLoading = true
        loadMarketData()
        updateOverviewData()
        
    }
    
    func loadMarketData()
    {
        APICaller.shared.getMarketData { result in
            switch result {
            case .marketSummarySuccess(let marketsummary):
                DispatchQueue.main.async {
                    self.marketData = marketsummary
                    self.isLoading = false
                }
                
            case .failure(let string):
                print("Error loading market summary: \(string)")
            default:
                print("error in loading marketsummary")
            }
        }
    }
    
    
    func updateOverviewData() {
        APICaller.shared.getQuoteData(searchSymbols: "^GSPC,^DJI,^IXIC") { result in
            switch result {
            case .success(let stockSnapShots):
                if let snpData = stockSnapShots.first(where: { $0.symbol == "^GSPC" }) {
                    DispatchQueue.main.async {
                        self.snpMarketStats = self.createStatisticModels(stockSnapshot: snpData)
                    }
                }
                if let dowData = stockSnapShots.first(where: { $0.symbol == "^DJI" }) {
                    DispatchQueue.main.async {
                        self.dowMarketStats = self.createStatisticModels(stockSnapshot: dowData)
                    }
                }
                if let nasdaqData = stockSnapShots.first(where: { $0.symbol == "^IXIC" }) {
                    DispatchQueue.main.async {
                        self.nasdaqMarketStats = self.createStatisticModels(stockSnapshot: nasdaqData)
                    }
                }
            case .failure(let string):
                print("Error getting overview stats: " + string)
                
            default:
                print("Error in getting overview data")
            }
        }
    }
    
    func updateDowData() {
        APICaller.shared.getQuoteData(searchSymbols: "^DJI") { result in
            switch result {
            case .success(let stockSnapShots):
                if let snpData = stockSnapShots.first(where: { $0.symbol == "^DJI" }) {
                    DispatchQueue.main.async {
                        self.snpMarketStats = self.createStatisticModels(stockSnapshot: snpData)
                    }
                }
            case .failure(let string):
                print("Error getting S&P stats: " + string)
                
            default:
                print("Error in getting S&P data")
            }
        }
    }
    
    func createStatisticModels(stockSnapshot: StockSnapshot) -> [StatisticModel]
    {
        let regularMarketPrice = stockSnapshot.regularMarketPrice.asCurrencyWith6Decimals()
        let priceStat = StatisticModel(title: "Price", value: regularMarketPrice)
//        let previousCloseStat = StatisticModel(title: "Previous Close", value: stockSnapshot.regularMarketPreviousClose.asCurrencyWith6Decimals())
//        let avgVolume3Month = Double(stockSnapshot.averageDailyVolume3Month).formattedWithAbbreviations()
//        let avgVolume3MonthStat = StatisticModel(title: "Average Volume 3 Months", value: avgVolume3Month)
//        let avgVolume10Day = Double(stockSnapshot.averageDailyVolume10Day).formattedWithAbbreviations()
//        let avgVolume10DayStat = StatisticModel(title: "Average Volume 10 Day", value: avgVolume10Day)
//        let volume = Double(stockSnapshot.regularMarketVolume).formattedWithAbbreviations()
//        let volumeStat = StatisticModel(title: "Regular Market Volume", value: volume)
//        let shares = Double(stockSnapshot.sharesOutstanding ?? 0).formattedWithAbbreviations()
//        let sharesOutstanding = StatisticModel(title: "Shares Outstanding", value: shares)
        let fiftyTwoWeekRange = StatisticModel(title: "FiftyTwo week range", value: stockSnapshot.fiftyTwoWeekRange)
//        let averageAnalystRating = StatisticModel(title: "Average Analyst Rating", value: stockSnapshot.averageAnalystRating ?? "n/a")
        
        let dayHighStat = StatisticModel(title: "Day High", value: stockSnapshot.regularMarketDayHigh.asCurrencyWith6Decimals())
        let dayLowStat = StatisticModel(title: "Day Low", value: stockSnapshot.regularMarketDayLow.asCurrencyWith6Decimals())
        let fiftyDayAvgStat = StatisticModel(title: "50 Day Average", value: (stockSnapshot.fiftyDayAverage ?? 0).asCurrencyWith2Decimals())
        let fiftyDayAvgChangeStat = StatisticModel(title: "50 Day Average Change", value: (stockSnapshot.fiftyDayAverageChange ?? 0).asCurrencyWith2Decimals(), percentageChange: (stockSnapshot.fiftyDayAverageChangePercent ?? 0) * 100)
        let twoHundredDayAvgStat = StatisticModel(title: "200 Day Average", value: stockSnapshot.twoHundredDayAverage.asCurrencyWith2Decimals())
        let twoHundredDayAvgChangeStat = StatisticModel(title: "200 Day Average Change", value: stockSnapshot.twoHundredDayAverageChange.asCurrencyWith2Decimals(), percentageChange: stockSnapshot.twoHundredDayAverageChangePercent * 100)
    
        
        return [priceStat, dayHighStat, dayLowStat,fiftyTwoWeekRange, fiftyDayAvgStat,fiftyDayAvgChangeStat,twoHundredDayAvgStat,twoHundredDayAvgChangeStat ]
    }
    
}
