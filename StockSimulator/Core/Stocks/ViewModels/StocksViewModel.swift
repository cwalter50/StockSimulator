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
