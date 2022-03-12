//
//  StockView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/29/22.
//

import SwiftUI

struct StockView: View {
    

    @State var stockSnapshot: StockSnapshot
    
    
    var body: some View {
        VStack {
            HStack (alignment: .firstTextBaseline){
                VStack(alignment: .leading){
                    Text(stockSnapshot.symbol)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(stockSnapshot.displayName)
                        .font(.body)
                        .foregroundColor(.secondary)
                        
                }
                Spacer()
                Text(String(format: "$%.2f", stockSnapshot.regularMarketPrice))
                    .font(.title)
            }
        }
        
    }
    
    
    
    
}


struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(stockSnapshot: StockSnapshot())
        
    }
}
