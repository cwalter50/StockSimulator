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
                Text(marketSummary.wrappedName)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(marketSummary.symbol)
                    .font(.headline)
                Text(marketSummary.regularMarketTime.fmt)

            }
            Spacer()
            VStack(alignment: .leading) {
                Text(marketSummary.market)
                Text(marketSummary.quoteType)
            }
            .font(.body)
            Spacer()
            VStack(alignment: .trailing) {
                Text(marketSummary.regularMarketPrice.fmt)
                HStack {
                    Image(systemName: marketSummary.regularMarketChange.raw >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    Text(marketSummary.regularMarketChangePercent.fmt)
                }
                
            }
            .font(.headline)
            .foregroundColor(marketSummary.regularMarketChange.raw >= 0 ? Color.theme.green : Color.theme.red)
        }
    }
}

struct MarketSummaryRow_Previews: PreviewProvider {
    static var previews: some View {
     
        MarketSummaryRow(marketSummary: MarketSummary())
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        MarketSummaryRow(marketSummary: MarketSummary())
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            
    }
}

