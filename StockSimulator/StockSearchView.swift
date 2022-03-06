//
//  StockSearchView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/12/22.
//

import SwiftUI

struct StockSearchView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    var watchlist: Watchlist
    var account: Account?
    
    @State var searchSymbol: String = ""
//    @State var foundStock: Bool = false
    @State var stockSnapshot: StockSnapshot?
    
    @State private var isTradePresented = false
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    init(watchlist: Watchlist)
    {
        self.watchlist = watchlist
    }
    
    init(theAccount: Account)
    {
        account = theAccount
        self.watchlist = Watchlist() // this will load the stocks from UserDefaults...// need to fix this
        
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
            
            if let theStockSnapshot = stockSnapshot
            {
                StockView(stock: theStockSnapshot)
                
                Button(action: {
                    saveToCoreData(snapshot: theStockSnapshot)
                    
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
                        .sheet(isPresented: $isTradePresented){
//                            TradeFormView(account: theAccount, stock: theStock)
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
        stockSnapshot = nil // this is needed so STOCKVIEW Reloads after looking up a Stock...
        let apiCaller = APICaller.shared
        apiCaller.getAllStockData(searchSymbol: searchSymbol) {
            connectionResult in
            
            switch connectionResult {
                case .success(let theStock):
                    stockSnapshot = theStock
//                    print("Success and should update stock to \(stock!.displayName)")
                case .failure(let error):
                    print(error)
                    stockSnapshot = nil
            }
        }
        
    }
    
    func saveToCoreData(snapshot: StockSnapshot)
    {
        // save stock to coredata...
        let newStock = Stock(context: moc)
        newStock.quoteType = snapshot.quoteType
        newStock.displayName = snapshot.displayName
        newStock.currency = snapshot.currency
        newStock.symbol = snapshot.symbol
        newStock.language = snapshot.language
        newStock.ask = snapshot.ask
        newStock.bid = snapshot.bid
        newStock.market = snapshot.market
        newStock.regularMarketDayLow = snapshot.regularMarketDayLow
        newStock.regularMarketDayHigh = snapshot.regularMarketDayHigh
        newStock.regularMarketPrice = snapshot.regularMarketPrice
        newStock.id = snapshot.id
        newStock.timeStamp = Date()
        
        // make relationship between stock and the watchlist
        newStock.addToWatchlists(watchlist)
        watchlist.addToStocks(newStock)
        
        try? moc.save() // save to CoreData
        
        print("watchlist has \(String(describing: watchlist.stocks?.count)) stocks")
        
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct StockSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StockSearchView(watchlist: Watchlist())
    }
}
