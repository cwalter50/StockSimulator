//
//  AssetView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/16/22.
//

import SwiftUI

struct AssetView: View {
    
    var asset: Asset
    var account: Account
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(asset.stock.wrappedSymbol)
            TradeFormView(account: account, stockSnapshot: StockSnapshot(stock: asset.stock))
        }
        .navigationTitle(asset.stock.wrappedSymbol)
        
    }
}

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView(asset: Asset(transactions: [], stock: Stock()), account: Account())
    }
}
