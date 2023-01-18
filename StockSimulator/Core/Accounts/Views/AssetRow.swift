//
//  AssetRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/12/22.
//

import SwiftUI

struct AssetRow: View{
    
    @ObservedObject var asset: Asset
    
    var body: some View {
        VStack {
            HStack (alignment: .firstTextBaseline){
                VStack(alignment: .leading){
                    Text(asset.stock.wrappedSymbol)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(String(format: "%.2f shares", asset.totalShares))
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .center) {
                    Text(String(format: "$%.2f", asset.totalValue))
                        .font(.title3)
                    Text(String(format: "$%.2f", asset.stock.regularMarketPrice))
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(String(format: "$%.2f", asset.amountChange))
                        .font(.title3)
                    Text(asset.percentChange.asPercentString())
                        .font(.body)
//                        .onTapGesture {
//                            print("\(asset.stock.symbol) percent change = \(asset.percentChange) and totalValue = \(asset.totalValue), cost basis = \(asset.costBasis)")
//                        }
                    
                }
                .foregroundColor(asset.amountChange < 0 ? Color.theme.red : Color.theme.green)
                
            }
        }
        .background {
            Color.theme.background.opacity(0.001)
        }
    }
}

struct AssetRow_Previews: PreviewProvider {
    static var previews: some View {
        let stock = dev.sampleStock
        AssetRow(asset: Asset(transactions: [], stock: stock))
    }
}
