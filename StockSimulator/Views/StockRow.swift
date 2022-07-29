//
//  StockRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/12/22.
//

import SwiftUI

struct StockRow: View {
    
    var stock: Stock
    
    var body: some View {
        HStack (alignment: .firstTextBaseline){
            VStack(alignment: .leading){
                Text(stock.symbol ?? "Unknown")
                    .font(.title)
                    .fontWeight(.bold)
                Text(stock.wrappedDisplayName)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack {
                Text(String(format: "$%.2f", stock.regularMarketPrice))
                                .font(.title)
                HStack {
                    Text(stock.regularMarketChangeFormatted)
                    
                    Text(stock.regularMarketChangePercentFormatted)
                }
                .foregroundColor(stock.regularMarketChange >= 0 ? Color.theme.green : Color.theme.red)
                .font(.headline)
            }

            
            
        }
        
        
    }
}

struct StockRow_Previews: PreviewProvider {
    static var previews: some View {

        StockRow(stock: Stock(context: dev.dataController.container.viewContext))
    }
}
