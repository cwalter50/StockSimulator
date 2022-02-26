//
//  WatchListView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/1/22.
//

import SwiftUI

struct WatchListView: View {
    
    @ObservedObject var watchList: WatchList
    
    @State private var isSearchPresented = false
    
    @Environment(\.editMode) private var editMode

    init() {
        watchList = WatchList()
        
// this is for testing before watchlist and userdefaults worked
//        watchList = WatchList(stocks: [Stock(), Stock(), Stock()])
    }
    
    init(test: Bool)
    {
        watchList = WatchList(stocks: [Stock(), Stock(), Stock()])
    }

    var body: some View {
        NavigationView {
            List {
//                StockView()
                ForEach(watchList.stocks) { stock in
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
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isSearchPresented, onDismiss: watchList.loadFromUserDefaults){
                        StockSearchView()
                    }

                }
                ToolbarItem {
                    EditButton()
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
                }
            }
            .navigationTitle("Watchlist")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        
    }
    
    func delete(at offsets: IndexSet) {
        watchList.stocks.remove(atOffsets: offsets)
        watchList.saveToUserDefaults()
//        watchList.saveToUserDefaults()
    }
    
    
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView(test: true)
    }
}
