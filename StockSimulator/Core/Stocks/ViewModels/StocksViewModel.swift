//
//  StocksViewModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 5/18/22.
//

import Foundation
import SwiftUI
import Combine

class StocksViewModel: ObservableObject {
    
    @Published var stockSnapshots: [StockSnapshot] = []
    
    @Published var marketData: [MarketSummary] = []
    
    @Published var watchlists: [Watchlist] = []
    
    @Published var snpMarketStats: [StatisticModel] = [] // this will display S&P market highlights on homeview
    
    
    @Published var isLoading: Bool = false
    
//    @Published var chartData: ChartData = ChartData()
    
    private let stockDataService = StockDataService()
    
//    @EnvironmentObject var dataController: DataController
//    private let dataController = DataController()

    private var cancellables = Set<AnyCancellable>()
    
    
    init()
    {
        addSubscribers()
    }
    
    // this is used to link the data on StockData Service with the data here on StockViewModel
    func addSubscribers() {
        stockDataService.$stockSnapshots
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnStocks in
                self?.stockSnapshots = returnStocks
            }
            .store(in: &cancellables)
        
        stockDataService.$marketData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedData in
                self?.isLoading = false
                self?.marketData = returnedData
            }
            .store(in: &cancellables)
        
//        stockDataService.$chartData
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] returnData in
//                self?.chartData = returnData
//            }
//            .store(in: &cancellables)

//        dataController.$savedWatchlists
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] returnWatchlists in
//                self?.watchlists = returnWatchlists
//
//            }
//            .store(in: &cancellables)
    }
    
//    func loadChartData(searchSymbol: String, range: String) {
//        stockDataService.getChartData(searchSymbol: searchSymbol, range: range)
//    }
    
    func loadStocks(searchSymbols: String)
    {
        stockDataService.getQuoteData(searchSymbols: searchSymbols)
    }
    
//    func updateStockPrices(searchSymbols: String, stocks: FetchedResults<Stock>)
//    {
//        stockDataService.updateStockData(searchSymbols: searchSymbols, stocks: stocks)
//    }
    
    func updateMarketData()
    {
        self.isLoading = true
        stockDataService.getMarketData()
        updatesnpData()
        
    }
    
    func updatesnpData() {
        APICaller.shared.getQuoteData(searchSymbols: "^GSPC") { result in
            switch result {
            case .success(let stockSnapShots):
                if let snpData = stockSnapShots.first(where: { $0.symbol == "^GSPC" }) {
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
        let previousCloseStat = StatisticModel(title: "Previous Close", value: stockSnapshot.regularMarketPreviousClose.asCurrencyWith6Decimals())
        let avgVolume3Month = Double(stockSnapshot.averageDailyVolume3Month).formattedWithAbbreviations()
        let avgVolume3MonthStat = StatisticModel(title: "Average Volume 3 Months", value: avgVolume3Month)
        let avgVolume10Day = Double(stockSnapshot.averageDailyVolume10Day).formattedWithAbbreviations()
        let avgVolume10DayStat = StatisticModel(title: "Average Volume 10 Day", value: avgVolume10Day)
        let volume = Double(stockSnapshot.regularMarketVolume).formattedWithAbbreviations()
        let volumeStat = StatisticModel(title: "Regular Market Volume", value: volume)
        let shares = Double(stockSnapshot.sharesOutstanding ?? 0).formattedWithAbbreviations()
        let sharesOutstanding = StatisticModel(title: "Shares Outstanding", value: shares)
        let fiftyTwoWeekRange = StatisticModel(title: "FiftyTwo week range", value: stockSnapshot.fiftyTwoWeekRange)
        let averageAnalystRating = StatisticModel(title: "Average Analyst Rating", value: stockSnapshot.averageAnalystRating ?? "n/a")
        
        let dayHighStat = StatisticModel(title: "Day High", value: stockSnapshot.regularMarketDayHigh.asCurrencyWith6Decimals())
        let dayLowStat = StatisticModel(title: "Day Low", value: stockSnapshot.regularMarketDayLow.asCurrencyWith6Decimals())
        let fiftyDayAvgStat = StatisticModel(title: "50 Day Average", value: (stockSnapshot.fiftyDayAverage ?? 0).asCurrencyWith2Decimals())
        let fiftyDayAvgChangeStat = StatisticModel(title: "50 Day Average Change", value: (stockSnapshot.fiftyDayAverageChange ?? 0).asCurrencyWith2Decimals(), percentageChange: (stockSnapshot.fiftyDayAverageChangePercent ?? 0) * 100)
        let twoHundredDayAvgStat = StatisticModel(title: "200 Day Average", value: stockSnapshot.twoHundredDayAverage.asCurrencyWith2Decimals())
        let twoHundredDayAvgChangeStat = StatisticModel(title: "200 Day Average Change", value: stockSnapshot.twoHundredDayAverageChange.asCurrencyWith2Decimals(), percentageChange: stockSnapshot.twoHundredDayAverageChangePercent * 100)
    
        
        return [priceStat, previousCloseStat, dayHighStat, dayLowStat, sharesOutstanding, volumeStat, avgVolume3MonthStat,avgVolume10DayStat, fiftyTwoWeekRange, fiftyDayAvgStat,fiftyDayAvgChangeStat,twoHundredDayAvgStat,twoHundredDayAvgChangeStat, averageAnalystRating ]
    }
    
    func updateMarketStats() {
//        let test = StatisticModel(title: "Test", value: "12.56", percentageChange: 0.15)
//        marketStats.append(test)
    }
    
    
    // For CoreData Watchlists..
    
//    func updateWatchlist(snapshot: StockSnapshot, watchlist: Watchlist?) {
//        dataController.updateWatchlist(snapshot: snapshot, watchlist: watchlist)
//    }
//    
//    func addWatchlist(name: String) {
//        dataController.addWatchlist(name: name)
//    }
//    
//    func deleteWatchlist(watchlist: Watchlist)
//    {
//        dataController.deleteWatchlist(watchlist: watchlist)
//    }
    
    
    
    
    
}
