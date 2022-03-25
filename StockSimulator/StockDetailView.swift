//
//  StockDetailView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/25/22.
//

import SwiftUI

struct StockDetailView: View {
    
    var stock: Stock
    
    var body: some View {
        VStack {
            StockBasicView(stockSnapshot: StockSnapshot(stock: stock))
//            ChartView()
            ChartView(stockSnapshot: StockSnapshot(stock: stock))
        }
        
        
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(stock: Stock())
    }
}
