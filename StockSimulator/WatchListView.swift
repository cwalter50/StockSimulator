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

    init() {
        watchList = WatchList()
        
// this is for testing before watchlist and userdefaults worked
//        watchList = WatchList(stocks: [Stock(), Stock(), Stock()])
    }
    
    
//    var investments: [Investment]
    var body: some View {
        NavigationView {
            List {
//                StockView()
                ForEach(watchList.stocks) { stock in
                    StockRow(stock: stock)
                }
                .onDelete(perform: delete)
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
        
        
    }
    
    func delete(at offsets: IndexSet) {
        watchList.stocks.remove(atOffsets: offsets)
//        watchList.saveToUserDefaults()
    }
    
    
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}
