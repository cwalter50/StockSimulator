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
                Text(stock.symbol)
                    .font(.title)
                    .fontWeight(.bold)
                Text(stock.displayName)
                    .font(.body)
                    .foregroundColor(.secondary)
                    
            }
            Spacer()
            Text(String(format: "$%.2f", stock.regularMarketPrice))
                .font(.title)
            
            
        }

        
    }
}

struct StockRow_Previews: PreviewProvider {
    static var previews: some View {

        StockRow(stock: Stock())
    }
}
