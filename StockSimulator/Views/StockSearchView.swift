//
//  StockSearchView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/12/22.
//

import SwiftUI

struct StockSearchView: View {
    
    @ObservedObject var vm = StocksViewModel()
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    var watchlist: Watchlist?
    var account: Account?
    
    @State var searchSymbol: String = ""
//    @State var foundStock: Bool = false
//    @State var stockSnapshots: [StockSnapshot] = []
    
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
                    .autocapitalization(.allCharacters)
                Button(action: getStockData) {
                    Text("Search")
                    
                }
                
            }
            .padding()
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Error"), message: Text("\(errorMessage)"), primaryButton: .default(Text("OK"), action: nil), secondaryButton: .cancel())
            }
                List {
                    ForEach(vm.stockSnapshots)
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
                .listStyle(PlainListStyle())

            Spacer()
        }
        .padding()
    }
    
    func getStockData()
    {
        searchSymbol = searchSymbol.replacingOccurrences(of: " ", with: "")
        vm.loadStocks(searchSymbols: searchSymbol)
    }
    
    func saveToWatchlistCoreData(snapshot: StockSnapshot)
    {
//        vm.updateWatchlist(snapshot: snapshot, watchlist: watchlist)
//        // save stock to coredata...
        let newStock = Stock(context: moc)
        newStock.updateValuesFromStockSnapshot(snapshot: snapshot)

        // make relationship between stock and the watchlist
        if let theWatchlist = watchlist, let theStocks = theWatchlist.stocks?.allObjects as? [Stock]
        {
            let allSymbols = theStocks.map({ $0.wrappedSymbol })
            if !allSymbols.contains(newStock.wrappedSymbol) {
                newStock.addToWatchlists(theWatchlist)
                theWatchlist.addToStocks(newStock)
            }

            if moc.hasChanges {
                try? moc.save() // save to CoreData
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct StockSearchView_Previews: PreviewProvider {
    static var previews: some View {
//        StockSearchView(watchlist: Watchlist(context: dev.dataController.container.viewContext))
        StockSearchView(watchlist: Watchlist())
            .environment(\.managedObjectContext, dev.dataController.container.viewContext)
    }
}
