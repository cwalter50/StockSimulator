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
    
    
    
    init (watchlist: Watchlist)
    {
        self.watchlist = watchlist
        
        self._stocks = FetchRequest(entity: Stock.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Stock.symbol, ascending: true)], predicate: NSPredicate(format: "(ANY watchlists == %@)", self.watchlist), animation: Animation.default)

    }

    var body: some View {
        VStack {
            Text(watchlist.name ?? "NoName")
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
                    .sheet(isPresented: $isSearchPresented){
                        StockSearchView(watchlist: watchlist)
                    }

                }
                ToolbarItem {
                    EditButton()
                }
            }
            .navigationTitle("\(watchlist.name ?? "Watchlist")")
        }
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
        
        
    }
    
    func delete(at offsets: IndexSet) {
//        watchList.stocks.remove(atOffsets: offsets)
//        watchList.saveToUserDefaults()
//        watchList.saveToUserDefaults()
    }
    
    
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView(watchlist: Watchlist())
    }
}

