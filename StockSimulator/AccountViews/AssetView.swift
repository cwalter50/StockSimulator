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
            Button(action: {
                getChartData()
            }){
               Text("Load Chart Data")
            }
            ChartView(stockSnapshot: StockSnapshot(stock: asset.stock))
            TradeFormView(account: account, stockSnapshot: StockSnapshot(stock: asset.stock))
            
        }
        .navigationTitle(asset.stock.wrappedSymbol)
        
    }
    
    
    func getChartData()
    {
//        stockSnapshots = []
//        stockSnapshot = nil // this is needed so STOCKVIEW Reloads after looking up a Stock...
        
        // remove all spaces from search symbol
        
        let searchSymbol = "AAPL"
        let apiCaller = APICaller.shared
        apiCaller.getChartData(searchSymbol: searchSymbol, range: "1mo") {
            connectionResult in
            
            switch connectionResult {
            case .success(_):
                print("success")
            case .chartSuccess(_):
                print("chartSuccess")
            case .failure(_):
                print("failure")
            }
        }
        
        
    }
}

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView(asset: Asset(transactions: [], stock: Stock()), account: Account())
    }
}
