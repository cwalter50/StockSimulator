//
//  HoldingView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/5/22.
//

import SwiftUI

struct HoldingView: View {
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    var holding: Holding
    var account: Account
    
    var stock: Stock
    
    init(holding: Holding, account: Account) {
        self.holding = holding
        self.account = account
//        if let theStock = holding.stock {
//            self.stock = theStock
//        }
        self.stock = holding.stock!

    }
    
    var body: some View {
        List {
            Section {
                StockBasicView(stockSnapshot: StockSnapshot(stock: stock))
                ChartView(symbol: stock.wrappedSymbol)
//                ChartView(stockSnapshot: StockSnapshot(stock: asset.stock))
                    .frame(height: 300)
            }
            yourSharesSection
            .font(.body)
            
            Section(header: Text("Trade Info")) {
                TradeFormView(account: account, stockSnapshot: StockSnapshot(stock: stock))
            }
            
        }
        .navigationTitle(stock.wrappedSymbol)
    }
}

struct HoldingView_Previews: PreviewProvider {
    static var previews: some View {
        HoldingView(holding: Holding(context: dev.dataController.container.viewContext), account: Account(context: dev.dataController.container.viewContext))
    }
}

extension HoldingView {
    
    private var yourSharesSection: some View {
        Section(header: Text("Your Shares")) {
            HStack{
                Text("Market Value:")
                Spacer()
                Text(String(format: "$%.2f", holding.totalValue))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            HStack {
                Text("Unrealized Gain:")
                Spacer()
                Text(String(format: "$%.2f", holding.amountChange))
                    .foregroundColor(holding.amountChange >= 0 ? Color.theme.green : Color.theme.red)
            }
            HStack {
                Text("Day Gain/Loss:")
                Spacer()
                Text(String(format: "$%.2f", holding.amountChange24h))
                    .foregroundColor(holding.amountChange24h >= 0 ? Color.theme.green : Color.theme.red)
            }
            HStack {
                Text("Quantity:")
                Spacer()
                Text(String(format: "%.2f", holding.numShares))
                    .foregroundColor(Color.theme.secondaryText)
            }
            HStack {
                Text("Average Price:")
                Spacer()
                Text(String(format: "$%.2f", holding.averagePurchasePrice))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}
