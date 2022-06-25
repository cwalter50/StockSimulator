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
            HStack(alignment: .top){
                VStack(alignment: .leading) {
                    Text("Symbol: \(marketSummary.symbol)")
                    Text("Market Time: \(marketSummary.regularMarketTime.fmt)")
                    Text("Previous Close: \(marketSummary.regularMarketPreviousClose.fmt)")
                    Text("Market: \(marketSummary.market)")
                    Text("Quote Type: \(marketSummary.quoteType)")
                    
                }
                .font(.body)
                Spacer()
                VStack {
                    Text("\(marketSummary.regularMarketPrice.fmt)")
                    HStack {
                        Image(systemName: marketSummary.regularMarketChange.raw >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        Text("\(marketSummary.regularMarketChangePercent.fmt)")
                    }
                    
                }
                .font(.headline)
                .foregroundColor(marketSummary.regularMarketChange.raw >= 0 ? Color.theme.green : Color.theme.red)
            }
            .padding()

  
            ChartView(stockSnapshot: stockSnapshot)
        }
        .navigationTitle(marketSummary.wrappedName)
        .onAppear(perform: loadStockSnapshot)
        
    }
    
    func loadStockSnapshot()
    {
        vm.loadStocks(searchSymbols: marketSummary.symbol)
        
    }
}

struct MarketSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MarketSummaryView(marketSummary: MarketSummary())
        }

    }
}
