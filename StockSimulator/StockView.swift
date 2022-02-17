//
//  StockView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/29/22.
//

import SwiftUI

struct StockView: View {
    

    @State var stock: Stock
    
    
    var body: some View {
        VStack {
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
    
    
    
    
}


struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(stock: Stock())
        
    }
}
