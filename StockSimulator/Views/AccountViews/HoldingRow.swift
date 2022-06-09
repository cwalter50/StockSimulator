//
//  HoldingRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/9/22.
//

import SwiftUI

struct HoldingRow: View {
    
    @ObservedObject var holding: Holding
    
    var body: some View {
        VStack {
            HStack (alignment: .firstTextBaseline){
                VStack(alignment: .leading){
                    Text(holding.stock!.wrappedSymbol)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(String(format: "%.2f shares", holding.totalShares))
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .center) {
                    Text(String(format: "$%.2f", holding.totalValue))
                        .font(.title3)
                    Text(String(format: "$%.2f", holding.stock!.regularMarketPrice))
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                }
                
                Spacer()
                VStack(alignment: .trailing) {
                    Text(String(format: "$%.2f", holding.amountChange))
                        .font(.title3)
                    Text(String(format: "%.2f", holding.percentChange)+"%")
                        .font(.body)
                }
                .foregroundColor(holding.amountChange < 0 ? Color.theme.red : Color.theme.green)
                
            }
        }
    }
}

struct HoldingRow_Previews: PreviewProvider {
    static var previews: some View {
        HoldingRow(holding: Holding(context: dev.dataController.container.viewContext))
//        AssetRow(asset: Asset(transactions: [Transaction()], stock: Stock()))
    }
}



