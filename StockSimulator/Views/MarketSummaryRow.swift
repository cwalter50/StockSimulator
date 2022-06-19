//
//  MarketSummaryRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/19/22.
//

import SwiftUI

struct MarketSummaryRow: View {
    
    var marketSummary: MarketSummary
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(marketSummary.fullExchangeName)
                    .font(.title)
                Text(marketSummary.symbol)
                    .font(.headline)
                
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(marketSummary.regularMarketPrice.fmt)
                HStack {
                    Image(systemName: marketSummary.regularMarketPrice.raw >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    Text(marketSummary.regularMarketChangePercent.fmt)
                }
                
            }
            .font(.headline)
            .foregroundColor(marketSummary.regularMarketPrice.raw >= 0 ? Color.theme.green : Color.theme.red)
        }
    }
}

struct MarketSummaryRow_Previews: PreviewProvider {
    static var previews: some View {
        MarketSummaryRow(marketSummary: MarketSummary())
    }
}
