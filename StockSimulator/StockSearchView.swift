//
//  StockSearchView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/12/22.
//

import SwiftUI

struct StockSearchView: View {
    
    @ObservedObject var watchList: WatchList
    var account: Account?
    
    @State var searchSymbol: String = ""
//    @State var foundStock: Bool = false
    @State var stock: Stock?
    
    @State private var isTradePresented = false
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    init()
    {
        self.watchList = WatchList() // this will load the stocks from UserDefaults...
    }
    
    init(theAccount: Account)
    {
        account = theAccount
        self.watchList = WatchList() // this will load the stocks from UserDefaults...
        
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter Stock Symbol", text: $searchSymbol)
//                TextField("StockSymbol", text: $searchSymbol, prompt: Text("Enter Stock Symbol"))
                    .autocapitalization(.allCharacters)
                
                Button(action: getStockData) {
                    Text("Search")
                }
                
            }
            .padding()
            
            if let theStock = stock
            {
                StockView(stock: theStock)
                
                Button(action: {
                    watchList.stocks.append(theStock)
//                  watchList.saveToUserDefaults()
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add to WatchList")
                }
                if let theAccount = account
                {
//                    HStack {
                        Button(action: {
                            isTradePresented.toggle()
                        }) {
                            Text("Trade")
                        }
                        .sheet(isPresented: $isTradePresented, onDismiss: watchList.loadFromUserDefaults){
                            TradeFormView(account: theAccount, stock: theStock)
                        }
//                        Button(action: {
//                            // Remove From Account
//                        }) {
//                            Text("SELL")
//                        }
//                        Button(action: {
//                            // Add to Account
//                        }) {
//                            Text("BUY")
//                        }
//                    }
                }

            }
            else {
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
    
    func getStockData()
    {
        stock = nil // this is needed so STOCKVIEW Reloads after looking up a Stock...
        let apiCaller = APICaller.shared
        apiCaller.getAllStockData(searchSymbol: searchSymbol) {
            connectionResult in
            
            switch connectionResult {
                case .success(let theStock):
                    stock = theStock
//                    print("Success and should update stock to \(stock!.displayName)")
                case .failure(let error):
                    print(error)
                    stock = nil
            }
        }
        
    }
}

struct StockSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StockSearchView()
    }
}
