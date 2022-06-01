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
    
    @Published var watchlists: [Watchlist] = []
    
    private let stockDataService = StockDataService()
//    private let watchlistDataService = WatchlistDataService()
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

//        watchlistDataService.$savedWatchlists
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] returnWatchlists in
//                self?.watchlists = returnWatchlists
//
//            }
//            .store(in: &cancellables)
    }
    
    func loadStocks(searchSymbols: String)
    {
        stockDataService.getQuoteData(searchSymbols: searchSymbols)
    }
    
    func updateWatchlist(snapshot: StockSnapshot, watchlist: Watchlist?) {
//        watchlistDataService.updateWatchlist(snapshot: snapshot, watchlist: watchlist)
    }
    
    
    
    
    
}
