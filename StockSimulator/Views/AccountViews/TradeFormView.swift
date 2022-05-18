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
        
        Group{
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
                StockBasicView(stockSnapshot: stockSnapshot)
            }
            Section(header: Text("TRADE INFO"))
            {
                Picker("Buy or Sell?", selection: $tradeType) {
                    ForEach(tradeOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
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
                Text(tradeType == "BUY" ? "Cost Basis: " + calculateTradePrice(): "Total Proceeds: " +  calculateTradePrice())
                    .font(.headline)
                
                Button(action: {
                    executeTrade()
//                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Trade")
                        .font(.title)
                        .foregroundColor(Color.blue)
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

    private func buyShares(numShares: Double)
    {
        // check if you can afford the trade first...
        if canAffordTrade()
        {
            let newTransaction = Transaction(context: moc)
            newTransaction.account = account
            newTransaction.id = UUID()
            newTransaction.buyDate = Date()
            newTransaction.purchasePrice = stockSnapshot.regularMarketPrice
            newTransaction.numShares = numShares
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
            
            alertMessage = "Successfully bought \(numShares) shares of \(stockSnapshot.symbol)"
            tradeStatus = .success
            displayAlert.toggle()
        }
        else {
            tradeStatus = .error
            alertMessage = "You do not have enough cash to make the transaction"
            displayAlert.toggle()
        }
    }
    
    private func sellShares(numShares: Double)
    {
        // see if you own the asset first
        if let theTransactionsSet = account.transactions, let transactions = Array(theTransactionsSet) as? [Transaction] {
            let filtered = transactions.filter({$0.stock?.symbol == stockSnapshot.symbol && $0.isClosed == false})
            
            // you own asset, so, start to sell
            if filtered.count > 0 {
                if let foundStock = transactions[0].stock {
                    let foundAsset = Asset(transactions: filtered, stock: foundStock)
                    
                    if numShares == foundAsset.totalShares { // sell everything and close all transactions
                        for t in filtered {
                            t.closeTransaction(sellPrice: stockSnapshot.regularMarketPrice)
                            
                            account.cash += t.totalProceeds
                            print("sold \(t.numShares) of \(foundStock.wrappedDisplayName)")
                        }
                        if moc.hasChanges {
                            try? moc.save()
                            print("Finished selling \(foundStock.wrappedSymbol): \(numShares) total shares sold. and saved to CoreData")
                        }
                        alertMessage = "Successfully sold \(numShares) shares of \(stockSnapshot.symbol)"
                        tradeStatus = .success
                        displayAlert.toggle()
                        
                    }
                    else if numShares < foundAsset.totalShares { // we can sell the shares.
                        // figure out how to sell asset. Use FILO. Right now just selling in any order
                        var numSold = 0.0
        
                        for t in filtered {
                            if numSold + t.numShares <= numShares {
                                // close this transaction. we can sell it all
                                t.closeTransaction(sellPrice: foundStock.regularMarketPrice)
                                numSold += t.numShares
                                account.cash += t.totalProceeds
                                print("sold \(t.numShares) of \(foundStock.wrappedDisplayName)")
                                if numSold == numShares
                                {
                                    break // need to break loop so that it doesnt finish the loop with filtered
                                }
                                
                            }
                            else if numSold + t.numShares > numShares {
                                // split transaction into 2. 1 that has the number of shares we are trying to sell and 1 thats a new one with the remaining shares that arent sold. delete the original transaction
                                let newTransactionOpen = Transaction(context: moc)
                                newTransactionOpen.copyTransaction(from: t)
                                
                                let newTranactionClose = Transaction(context: moc)
                                newTranactionClose.copyTransaction(from: t)
                                
                                newTranactionClose.numShares = numShares - numSold
                                
                                newTranactionClose.closeTransaction(sellPrice: stockSnapshot.regularMarketPrice)
                                
                                newTransactionOpen.numShares -= newTranactionClose.numShares

                                account.addToTransactions(newTranactionClose)
                                account.addToTransactions(newTransactionOpen)
                                
                                account.removeFromTransactions(t)
                                
                                numSold = numShares // we just sold them all
                                account.cash += newTranactionClose.totalProceeds
                                print("sold \(newTranactionClose.numShares) of \(foundStock.wrappedDisplayName)")
                                break // break the loop, because we sold the amount specified
                            }
                        }
                        if moc.hasChanges {
                            try? moc.save()
                            print("Finished selling \(foundStock.wrappedSymbol): \(numShares) total shares sold. and saved to CoreData")
                        }
                        alertMessage = "Successfully sold \(numShares) shares of \(stockSnapshot.symbol)"
                        tradeStatus = .success
                        displayAlert.toggle()
                    }
                    else {
                        // numSharesNum > thatn the number of shares that you own
                        
                        tradeStatus = .error
                        alertMessage = "Cannot sell: You do not own \(numShares) shares of \(stockSnapshot.symbol)"
                        displayAlert.toggle()
                    }
                }
                else {
                    tradeStatus = .error
                    alertMessage = "Cannot sell: You do not own \(numShares) shares of \(stockSnapshot.symbol)"
                    displayAlert.toggle()
                }
                
            }
            else {
                tradeStatus = .error
                alertMessage = "Cannot sell: You do not own \(numShares) shares of \(stockSnapshot.symbol)"
                displayAlert.toggle()
            }
        }
        else {
            tradeStatus = .error
            alertMessage = "Cannot sell: You do not own \(numShares) shares of \(stockSnapshot.symbol)"
            displayAlert.toggle()
        }
    }
    
    func executeTrade()
    {
        if let numSharesNum = Double(numShares)
        {
            if tradeType == "BUY"
            {
                buyShares(numShares: numSharesNum)
            }
            else { // sell shares

                sellShares(numShares: numSharesNum)
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
            return String(format: "$%.2f", num)
        }
        else {
            return "$0.00"
        }
       
    }
}

struct TradeFormView_Previews: PreviewProvider {
    static var previews: some View {
        TradeFormView(account: Account(), stockSnapshot: StockSnapshot())
    }
}