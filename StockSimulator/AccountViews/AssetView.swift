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
        List {
            Section {
                StockBasicView(stockSnapshot: StockSnapshot(stock: asset.stock))
                ChartView(stockSnapshot: StockSnapshot(stock: asset.stock))
//                StockDetailView(stock: asset.stock)
                    .frame(height: 300)
//                    .padding()
            }
//            .padding([.bottom], 20)
            
            yourSharesSection
            .font(.body)
            
            Section(header: Text("Trade Info")) {
                TradeFormView(account: account, stockSnapshot: StockSnapshot(stock: asset.stock))
            }
            
            
            
            
            
            
            
//            TradeFormView(account: account, stockSnapshot: StockSnapshot(stock: asset.stock))
//            Spacer()
            
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

extension AssetView {
    
    private var yourSharesSection: some View {
        Section(header: Text("Your Shares")) {
            HStack{
                Text("Market Value:")
                Spacer()
                Text(String(format: "$%.2f", asset.totalValue))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            HStack {
                Text("Unrealized Gain:")
                Spacer()
                Text(String(format: "$%.2f", asset.amountChange))
                    .foregroundColor(asset.amountChange >= 0 ? Color.theme.green : Color.theme.red)
            }
            HStack {
                Text("Day Gain/Loss:")
                Spacer()
                Text("ToDo: Figure out")
                    .foregroundColor(Color.theme.secondaryText)
            }
            HStack {
                Text("Quantity:")
                Spacer()
                Text(String(format: "%.2f", asset.totalShares))
                    .foregroundColor(Color.theme.secondaryText)
            }
            HStack {
                Text("Average Price:")
                Spacer()
                Text(String(format: "$%.2f", asset.averagePurchasePrice))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}
