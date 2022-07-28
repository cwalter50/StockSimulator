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
    
    var stockSnapshot: StockSnapshot
    
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
        let previousClose = stock.regularMarketPreviousClose.asCurrencyWith6Decimals()
        let previousCloseStat = StatisticModel(title: "Previous Close", value: previousClose)
        let marketCap = Double(stock.marketCap).formattedWithAbbreviations()
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap)
        let shares = Double(stock.sharesOutstanding).formattedWithAbbreviations()
        let sharesOutstanding = StatisticModel(title: "Shares Outstanding", value: shares)
        let fiftyTwoWeekRange = StatisticModel(title: "FiftyTwo week range", value: stock.fiftyTwoWeekRange ?? "n/a")
        let averageAnalystRating = StatisticModel(title: "Average Analyst Rating", value: stock.averageAnalystRating ?? "n/a")


        overviewStatistics = [previousCloseStat,marketCapStat, sharesOutstanding, fiftyTwoWeekRange, averageAnalystRating]
    }
    
    private func loadCryptoStats()
    {
        let volume = Double(stock.volume24Hr ?? 0).formattedWithAbbreviations()
        let volume24Hr = StatisticModel(title: "24Hr Volume", value: volume)
        let high = StatisticModel(title: "Fifty-Two Week High", value: stock.fiftyTwoWeekHigh.asCurrencyWith6Decimals())
        let currency = StatisticModel(title: "Currency", value: stock.currency ?? "n/a")
        overviewStatistics = [volume24Hr, high, currency]
    }
}
