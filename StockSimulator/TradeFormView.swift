//
//  TradeFormView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import SwiftUI
import Combine

enum TradeStatus: String
{
    case success = "Succes"
    case error = "Error"
}

struct TradeFormView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    var account: Account
    var stockSnapshot: StockSnapshot
    
    @State var tradeType: String = "BUY" // this should be BUY or SELL
    var tradeOptions = ["BUY", "SELL"]
    
    @State var numShares: String = ""
    
    @State var displayAlert = false
//    @State var alertTitle = ""
    @State var alertMessage = ""
    
    @State var tradeStatus = TradeStatus.error
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View
    {
        Form {
            Section(header: Text("ACCOUNT INFO")) {
                VStack(alignment: .leading) {
                    Text(account.wrappedName)
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
                StockView(stockSnapshot: stockSnapshot)
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
            .alert(isPresented: $displayAlert) {
                Alert(title: Text(tradeStatus.rawValue), message: Text(alertMessage), dismissButton: Alert.Button.default(Text("OK")){
                    // dismiss the page if the alert was a success...
                    if tradeStatus == .success {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
            
        }

        
    }
    
    
    func saveAllAccountsToUserDefaults()
    {
        
    }
    
    
    func executeTrade()
    {
        if let numSharesNum = Double(numShares)
        {
            if tradeType == "BUY"
            {
            
                // check if you can afford the trade first...
                if canAffordTrade()
                {
                    let newTransaction = Transaction(context: moc)
                    newTransaction.account = account
                    newTransaction.id = UUID()
                    newTransaction.buyDate = Date()
                    newTransaction.purchasePrice = stockSnapshot.regularMarketPrice
                    newTransaction.numShares = numSharesNum
                    newTransaction.costBasis = numSharesNum * stockSnapshot.regularMarketPrice // cost basis is when we buy
                    newTransaction.totalProceeds = 0 // proceeds are when we sell
                    newTransaction.isClosed = false
                    
                    let newStock = Stock(context: moc)
                    newStock.updateValuesFromStockSnapshot(snapshot: stockSnapshot)
                    
                    newTransaction.stock = newStock
                    newTransaction.account = account
                    
                    account.addToTransactions(newTransaction) // might not need this. I think the line above is the same thing...
                    
                    
                    // decrease cash amount in account by purchase price
                    account.cash -= newTransaction.costBasis
                    
                    
                    if moc.hasChanges {
                        try? moc.save() // save to CoreData
                        print("transaction has been added to account")
                    }
                    
                    alertMessage = "Successfully bought \(numSharesNum) shares of \(stockSnapshot.symbol)"
                    tradeStatus = .success
                    displayAlert.toggle()
                    
                }
                else {
                    tradeStatus = .error
                    alertMessage = "You do not have enough cash to make the transaction"
                    displayAlert.toggle()
                }
            }
            else { // sell shares
                // see if you own the asset first
                if let theTransactionsSet = account.transactions, let transactions = Array(theTransactionsSet) as? [Transaction] {
                    let filtered = transactions.filter({$0.stock?.symbol == stockSnapshot.symbol})
                    
                    if transactions.count > 0 {
                        if let foundStock = transactions[0].stock {
                            let foundAsset = Asset(transactions: filtered, stock: foundStock)
                            
                            if numSharesNum < foundAsset.totalShares { // we can sell the shares.
                                // figure out how to sell asset
                            }
                            else {
                                tradeStatus = .error
                                alertMessage = "Cannot sell: You do not own \(numSharesNum) shares of \(foundStock.wrappedSymbol)"
                                displayAlert.toggle()
                                
                            }
                        
                        }
                        
                    }
                    else {
                        tradeStatus = .error
                        alertMessage = "Cannot sell: You do not own \(numSharesNum) shares of \(stockSnapshot.symbol)"
                        displayAlert.toggle()
                    }
                }
                else {
                    tradeStatus = .error
                    alertMessage = "Cannot sell: You do not own \(numSharesNum) shares of \(stockSnapshot.symbol)"
                    displayAlert.toggle()
                }
            
            }
        }

    }
    
    func canAffordTrade() -> Bool
    {
        if let numSharesNumber = Double(numShares)
        {
            return account.cash > stockSnapshot.regularMarketPrice * numSharesNumber
        }
        return false
    }
    
    func calculateTradePrice() -> String
    {
        if let numSharesNumber = Double(numShares) {

            let num = stockSnapshot.regularMarketPrice * numSharesNumber
            return String(format: "Cost Basis: $%.2f", num)
        }
        else {
            return "Cost Basis: $0.00"
        }
       
    }
}

struct TradeFormView_Previews: PreviewProvider {
    static var previews: some View {
        TradeFormView(account: Account(), stockSnapshot: StockSnapshot())
    }
}
