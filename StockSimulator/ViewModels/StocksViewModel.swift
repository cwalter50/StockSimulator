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
    
    func addSubscribers() {
        
//        $stockSnapshots
//            .combineLatest(stockDataService.$stockSnapshots)
//            .map { 
//                
//            }
//            .sink { [weak self] returnedStocks in
//                self?.stockSnapshots = returnedStocks
//                
//            }
            
    }
    
    func loadStocks(searchSymbols: String)
    {
        stockDataService.getQuoteData(searchSymbols: searchSymbols)
        
    }
    
    
}
