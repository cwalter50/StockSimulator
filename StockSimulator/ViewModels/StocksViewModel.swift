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
    
    private let stockDataService = StockDataService()
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
    }
    
    func loadStocks(searchSymbols: String)
    {
        stockDataService.getQuoteData(searchSymbols: searchSymbols)

        
    }
    
    
    
    
}
