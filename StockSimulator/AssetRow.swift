//
//  AssetRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/12/22.
//

import SwiftUI

struct AssetRow: View{
    
    var asset: Asset
    var body: some View {
        VStack {
            HStack (alignment: .firstTextBaseline){
                VStack(alignment: .leading){
                    Text(asset.stock.wrappedSymbol)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(asset.stock.wrappedDisplayName)
                        .font(.body)
                        .foregroundColor(.secondary)
                        
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(String(format: "$%.2f", asset.totalValue))
                        .font(.title)
                    Text(String(format: "%.2f shares", asset.totalShares))
                }
                
            }
        }
    }
}

struct AssetRow_Previews: PreviewProvider {
    static var previews: some View {
        AssetRow(asset: Asset(transactions: [Transaction()], stock: Stock()))
    }
}
