//
//  WatchlistView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/4/22.
//



import SwiftUI

struct WatchlistView: View {
    
    var watchlist: Watchlist
    
    @State private var isSearchPresented = false
    
    @Environment(\.editMode) private var editMode
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
//    @EnvironmentObject var vm : StocksViewModel
    
    
    @FetchRequest var stocks: FetchedResults<Stock> // stocks need load in init, because FetchRequest requires a predicate with the variable watchlist
    
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    init (watchlist: Watchlist)
    {
        self.watchlist = watchlist
        
        self._stocks = FetchRequest(entity: Stock.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Stock.symbol, ascending: true)], predicate: NSPredicate(format: "(ANY watchlists == %@)", self.watchlist), animation: Animation.default)

    }

    var body: some View {
        VStack {
            List {
                ForEach(stocks) { stock in
                    NavigationLink(
                        destination: StockDetailView(stock: stock)) {
                        StockRow(stock: stock)
                        }.isDetailLink(false)

                }
                .onDelete(perform: delete)
                
            }
            .listStyle(PlainListStyle())

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        loadCurrentStockInfo()
                        HapticManager.notification(type: .success)
                    }) {
//                        Text("Reload")
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSearchPresented.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .sheet(isPresented: $isSearchPresented, onDismiss: loadCurrentStockInfo) {
                        StockSearchView(watchlist: watchlist)
                    }
                }
                ToolbarItem {
                    EditButton()
                }
                
            }
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Error"), message: Text("\(errorMessage)"), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("\(watchlist.name ?? "Watchlist")")
            .navigationViewStyle(.stack)
            
        
            .onAppear(perform: loadCurrentStockInfo)
        }
    }
    
    func loadCurrentStockInfo()
    {
//        print("onAppear called")
        var searchString = ""
        for s in stocks
        {
            searchString += s.wrappedSymbol+","
        }
//        vm.updateStockPrices(searchSymbols: searchString, stocks: stocks)
        let apiCaller = APICaller.shared
        apiCaller.getQuoteData(searchSymbols: searchString) {
            connectionResult in
            switch connectionResult {
                case .success(let theStocks):
                    // link the stocks to the current stock prices, update the values,
                    for snapshot in theStocks
                    {
                        if let stockCoreData = stocks.first(where: {$0.symbol == snapshot.symbol}) {
                            stockCoreData.updateValuesFromStockSnapshot(snapshot: snapshot)

                            print("updated values for \(stockCoreData.wrappedSymbol)")
                        }
                    }
                DispatchQueue.main.async {
                    try? moc.save()
                }
                   
                case .failure(let error):
                    print(error)
                    errorMessage = error
                    if stocks.count > 0 {
                        showingErrorAlert = true
                    }
                default:
                    print("ConnectionResult is not success or failure")
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        
        for index in offsets {
            let stock = stocks[index]
            moc.delete(stock)
        }
        try? moc.save()
    }
    
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        let context = dev.dataController.container.viewContext
        //Test data

        
        return
        NavigationView {
            WatchlistView(watchlist: dev.sampleWatchlist)
                .environment(\.managedObjectContext, context)
                .navigationViewStyle(.stack)
        }
        
        
//            .environmentObject(dev.stockVM)
        
    }
}

