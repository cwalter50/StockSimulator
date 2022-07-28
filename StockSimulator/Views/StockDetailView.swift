//
//  StockDetailView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/25/22.
//

import SwiftUI

struct StockDetailView: View {
    
    private let stock: Stock
//    private let additionalInfo: [StatisticModel]
    
    @StateObject var vm: StockDetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(stock: Stock)
    {
        // load most recent data for stock
        self.stock = stock
        
        _vm = StateObject(wrappedValue: StockDetailViewModel(stock: stock))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                StockBasicView(stockSnapshot: StockSnapshot(stock: stock))
                Divider()
                

                ChartView(symbol: stock.wrappedSymbol)
                    .frame(height: 300)
                Text("Overview")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: nil,
                    pinnedViews: [],
                    content: {
                        ForEach(vm.overviewStatistics) { stat in
                            StatisticView(stat: stat)
                            
                        }
                })
                Spacer()
            }.padding()
        }
        
        
        
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stock: dev.sampleStock)
        }
        
    }
}
