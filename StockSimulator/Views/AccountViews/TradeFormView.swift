//
//  TradeFormView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import SwiftUI
import Combine

//enum TradeStatus: String
//{
//    case success = "Success"
//    case error = "Error"
//}
struct TradeFormView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    var account: Account
    var stockSnapshot: StockSnapshot
    
    @ObservedObject var vm: AccountViewModel
    
    @State var tradeType: String = "BUY" // this should be BUY or SELL
    var tradeOptions = ["BUY", "SELL", "SELL ALL"]
    
    @State var numShares: String = ""
    
    @State var displayAlert = false
    @State var alertMessage = ""
    @State var alertTitle = "Error"
//    @State var alertStatus:TradeStatus = TradeStatus.error
    
    @State var tradeCompleted = false
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    
    init(account: Account, stockSnapshot: StockSnapshot)
    {
        self.account = account
        self.stockSnapshot = stockSnapshot
        vm = AccountViewModel(account: account)
    }
    
    var body: some View
    {
        VStack {
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
                        .onChange(of: tradeType) { tag in
                            if tag == "SELL ALL" {
                                let asset = account.assets.first(where: {$0.stock.symbol == stockSnapshot.symbol})
                                numShares = "\(asset?.totalShares ?? 0.0)"
                            }
                            else {
                                numShares = ""
                            }
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
                                let filtered = newValue.filter { "0123456789.".contains($0) }
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
                    
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: Alert.Button.default(Text("OK")){
                        // dismiss the page if the alert was a success...
                        if tradeCompleted == true {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
                
            }
        }
        .padding()
        
    }
    
    func executeTrade()
    {
        if tradeType == "BUY"
        {
            if let numSharesNum = Double(numShares) {
                buyShares(numShares: numSharesNum)
            }
        }
        else if tradeType == "SELL"{ // sell shares
            if let numSharesNum = Double(numShares) {
                sellShares(numShares: numSharesNum)
            }
            
        }
        else { // sell all shares
            sellAllShares()
        }
    }
    
    private func buyShares(numShares: Double)
    {
        vm.buyShares(numShares: numShares, stockSnapshot: stockSnapshot, context: moc) { tradeStatus in
            switch tradeStatus {
            case .buySuccess(let title, let message), .sellSuccess(let title, let message), .sellAllSuccess(let title, let message):
                alertTitle = title
                alertMessage = message
                tradeCompleted = true
            case .error(let title, let message):
                alertTitle = title
                alertMessage = message
                tradeCompleted = false
            }
            displayAlert.toggle()
        }
    }

    private func sellAllShares()
    {
        print("sellAll")
        vm.sellAllShares(stockSnapshot: stockSnapshot, context: moc) { tradeStatus in
            switch tradeStatus {
            case .buySuccess(let title, let message), .sellSuccess(let title, let message), .sellAllSuccess(let title, let message):
                alertTitle = title
                alertMessage = message
                tradeCompleted = true
            case .error(let title, let message):
                alertTitle = title
                alertMessage = message
                tradeCompleted = false
            }
        }
        displayAlert.toggle()
    }
    private func sellShares(numShares: Double)
    {

        vm.sellShares(numShares: numShares, stockSnapshot: stockSnapshot, context: moc) { tradeStatus in
            switch tradeStatus {
            case .buySuccess(let title, let message), .sellSuccess(let title, let message), .sellAllSuccess(let title, let message):
                alertTitle = title
                alertMessage = message
                tradeCompleted = true
                displayAlert.toggle()
            case .error(let title, let message):
                alertTitle = title
                alertMessage = message
                tradeCompleted = false
                displayAlert.toggle()
            }
        }
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
//        let context = dev.dataController.container.viewContext
//        return TradeFormView(account: dev.sampleAccount(), stockSnapshot: StockSnapshot())
//            .environment(\.managedObjectContext, context)
        TradeFormView(account: dev.sampleAccount, stockSnapshot: StockSnapshot())
                .environment(\.managedObjectContext, dev.dataController.container.viewContext)
    }
}
