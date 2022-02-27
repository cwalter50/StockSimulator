//
//  TradeFormView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import SwiftUI
import Combine

struct TradeFormView: View {
    
    var account: Account
    var stock: Stock
    
    @State var tradeType: String = "BUY" // this should be BUY or SELL
    var tradeOptions = ["BUY", "SELL"]
    
    @State var numShares: String = ""
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View
    {
        Form {
            Section(header: Text("ACCOUNT INFO")) {
                VStack(alignment: .leading) {
                    Text(account.name)
                        .font(.title)
                        .fontWeight(.bold)
                    HStack (alignment: .firstTextBaseline){
                        Text("Available Cash: ")
                        Spacer()
                        Text(String(format: "$%.2f", account.cash))
                    }
                    .font(.headline)
//                    .padding([.vertical])
                }
            }
            Section(header: Text("STOCK INFO"))
            {
                StockView(stock: stock)
            }
            Section(header: Text("TRADE INFO"))
            {
                Picker("Buy or Sell?", selection: $tradeType) {
                    ForEach(tradeOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                HStack(alignment: .firstTextBaseline) {
                    Text("Shares: ")
                        .font(.headline)
                    TextField("Number of Shares",  text: $numShares)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .onReceive(Just(numShares)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.numShares = filtered
                            }
                        }
                }
                Text(calculateTradePrice())
                    .font(.headline)
                
                Button(action: {
                    executeTrade()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Trade")
                        .font(.title)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
                

                
            }
            
        }

        
    }
    
    
    func saveAllAccountsToUserDefaults()
    {
        
    }
    
    
    func executeTrade()
    {
        if tradeType == "BUY"
        {
            if let numSharesNum = Double(numShares)
            {
                let result = account.buyAsset(numShares: numSharesNum, stock: stock)
                if result == true
                {
                    print("successfully bought \(numSharesNum) \(stock.symbol) for \(stock.regularMarketPrice)")
                }
                else
                {
                    print("unable to buy stock.")
                }
            }
            
        }
        else if tradeType == "SELL"
        {
            if let numSharesNum = Double(numShares)
            {
                let result = account.sellAsset(numShares: numSharesNum, stock: stock)
                if result == true
                {
                    print("successfully sold \(numSharesNum) \(stock.symbol) for \(stock.regularMarketPrice)")
                }
                else
                {
                    print("unable to sell stock.")
                }
            }
        }
    }
    
    func calculateTradePrice() -> String
    {
        if let numSharesNumber = Double(numShares) {
            
            let num = stock.regularMarketPrice * numSharesNumber
            return String(format: "Cost Basis: $%.2f", num)
        }
        else {
            return "Cost Basis: $0.00"
        }
    }
}

struct TradeFormView_Previews: PreviewProvider {
    static var previews: some View {
        TradeFormView(account: Account(), stock: Stock())
    }
}
