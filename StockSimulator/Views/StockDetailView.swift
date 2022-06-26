//
//  StockDetailView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/25/22.
//

import SwiftUI

struct StockDetailView: View {
    
    var stock: Stock
    
//    init(stock: Stock)
//    {
//        // load most recent data for stock
//        self.stock = stock
//        
//    }
    
    var body: some View {
        VStack {
            StockBasicView(stockSnapshot: StockSnapshot(stock: stock))
//            ChartView(stockSnapshot: StockSnapshot(stock: stock))
            ChartView(symbol: stock.wrappedSymbol)
                .frame(height: 300)
            Spacer()
        }.padding()
        
        
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(stock: dev.sampleStock())
    }
}
