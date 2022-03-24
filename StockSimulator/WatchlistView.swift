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
    
    @State var isShowingPullToRequest = false
    
    init (watchlist: Watchlist)
    {
        self.watchlist = watchlist
        
        self._stocks = FetchRequest(entity: Stock.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Stock.symbol, ascending: true)], predicate: NSPredicate(format: "(ANY watchlists == %@)", self.watchlist), animation: Animation.default)

    }

    var body: some View {
        VStack {
            List {

                ForEach(stocks) { stock in
                    StockRow(stock: stock)
                    
                }
                .onDelete(perform: delete)
//                .deleteDisabled(editMode?.wrappedValue != .active)
            }
            
            .toolbar {
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
        apiCaller.getAllStockData(searchSymbol: searchString) {
            connectionResult in
            
            switch connectionResult {
                case .success(let theStocks):
                    // link the stocks to the current stock prices, update the values,
                    for snapshot in theStocks
                    {
                        if let stockCoreData = stocks.first(where: {$0.symbol == snapshot.symbol}) {
                            stockCoreData.updateValuesFromStockSnapshot(snapshot: snapshot)
                            
//                            var rand = Int.random(in: 1...100)
//                            stockCoreData.displayName = "Pear\(rand)"
                            print("updated values for \(stockCoreData.wrappedSymbol)")
                        }
                    }
                    try? moc.save()
                    

                case .failure(let error):
                    print(error)
                case .chartSuccess(let theString):
                    print("ChartSuccess")

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
        WatchlistView(watchlist: Watchlist())
    }
}

