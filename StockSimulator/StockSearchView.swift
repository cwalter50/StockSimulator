//
//  StockSearchView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/12/22.
//

import SwiftUI

struct StockSearchView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    var watchlist: Watchlist?
    var account: Account?
    
    @State var searchSymbol: String = ""
//    @State var foundStock: Bool = false
    @State var stockSnapshots: [StockSnapshot] = []
    
    @State private var isTradePresented = false
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    init(watchlist: Watchlist)
    {
        self.watchlist = watchlist
//        stockSnapshot = []
    }
    
    init(theAccount: Account)
    {
        account = theAccount
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
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Error"), message: Text("\(errorMessage)"), primaryButton: .default(Text("OK"), action: nil), secondaryButton: .cancel())
            }
            
//            if let theStockSnapshot = stockSnapshot
//            {
                List {
                    ForEach(stockSnapshots)
                    {
                        stockSnapshot in
                        StockBasicView(stockSnapshot: stockSnapshot)
                        if watchlist != nil
                        {
                            Button(action: {
                                saveToWatchlistCoreData(snapshot: stockSnapshot)
                                
                            }) {
                                Text("Add to WatchList")
                                    .foregroundColor(Color.blue)
                            }
                        }
                        if let theAccount = account
                        {
                            Button(action: {
                                isTradePresented.toggle()
                            }) {
                                Text("Trade")
                                    .foregroundColor(Color.blue)
                            }
                            .sheet(isPresented: $isTradePresented){
                                List {
                                TradeFormView(account: theAccount, stockSnapshot: stockSnapshot)
                                }
                            }
                        }
                        
                        
                    }
                }

            Spacer()
        }
        .padding()
    }
    
    

    
    func getStockData()
    {
        stockSnapshots = []
//        stockSnapshot = nil // this is needed so STOCKVIEW Reloads after looking up a Stock...
        
        // remove all spaces from search symbol
        
        searchSymbol = searchSymbol.replacingOccurrences(of: " ", with: "")
        let apiCaller = APICaller.shared
        apiCaller.getQuoteData(searchSymbols: searchSymbol) {
            connectionResult in
            
            switch connectionResult {
                case .success(let theStocks):
                    stockSnapshots = theStocks
//                    print("Success and should update stock to \(stock!.displayName)")
                case .failure(let error):
                    print(error)
                    stockSnapshots = []
                    errorMessage = error
                    showingErrorAlert = true
                case .chartSuccess(let theAnswer):
                    print("Chart Success \(theAnswer)")
            }
        }
        
    }
    
    func saveToWatchlistCoreData(snapshot: StockSnapshot)
    {
        // save stock to coredata...
        let newStock = Stock(context: moc)
        newStock.updateValuesFromStockSnapshot(snapshot: snapshot)

        // make relationship between stock and the watchlist
        if let theWatchlist = watchlist
        {
            newStock.addToWatchlists(theWatchlist)
            theWatchlist.addToStocks(newStock)

            try? moc.save() // save to CoreData

            print("watchlist has \(String(describing: theWatchlist.stocks?.count)) stocks")
        }

        presentationMode.wrappedValue.dismiss()
    }
    
}

struct StockSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StockSearchView(watchlist: Watchlist())
    }
}
