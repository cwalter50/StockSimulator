//
//  MarketSummaryView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/19/22.
//

import SwiftUI

struct MarketSummaryView: View {
    
    var marketSummary: MarketSummary
    
    @State var stockSnapshot: StockSnapshot = StockSnapshot()
    
    @ObservedObject var vm = StocksViewModel()
    
    var body: some View {
        VStack {
            MarketSummaryRow(marketSummary: marketSummary)
            ChartView(stockSnapshot: stockSnapshot)
        }
        .onAppear(perform: loadStockSnapshot)
        
    }
    
    func loadStockSnapshot()
    {
        vm.loadStocks(searchSymbols: marketSummary.symbol)
        
    }
}

struct MarketSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MarketSummaryView(marketSummary: MarketSummary())
    }
}
