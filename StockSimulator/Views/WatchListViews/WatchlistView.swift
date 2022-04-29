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
                    }
                    
                }
                .onDelete(perform: delete)
                
            }
            .listStyle(PlainListStyle())

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        loadCurrentStockInfo()
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
                    try? moc.save()
                    

                case .failure(let error):
                    print(error)
                    errorMessage = error
                    showingErrorAlert = true
                
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
        let context = PersistenceController.preview.container.viewContext
        //Test data
        let newWatchlist = Watchlist.init(context: context)
        newWatchlist.name = "Sample"
        
        return WatchlistView(watchlist: newWatchlist).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        
//        WatchlistView(watchlist: Watchlist(context: DataController().container.viewContext))


//            .environment(\.managedObjectContext, DataController().container.viewContext)
    }
}

