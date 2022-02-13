//
//  WatchListView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/1/22.
//

import SwiftUI

struct WatchListView: View {
    @State var watchList: WatchList
    

    init() {
        if let data = UserDefaults.standard.data(forKey: "watchList") {
            if let decoded = try? JSONDecoder().decode(WatchList.self, from: data) {
                watchList = decoded
                return
            }
        }
        
//        watchList = WatchList(stocks: [])
        watchList = WatchList(stocks: [Stock(), Stock(), Stock()])
    }
    
    
//    var investments: [Investment]
    var body: some View {
        NavigationView {
            List {
                StockView()
                ForEach(watchList.stocks) { stock in
                    StockRow(stock: stock)
                }
                .onDelete(perform: delete)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        NavigationLink( destination: StockSearchView()) {
                            Image(systemName: "plus")
                        }
                    }
//                    EditButton()
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
    
    
    func saveWatchListToUserDefaults()
    {
        if let encoded = try? JSONEncoder().encode(watchList) {
            UserDefaults.standard.set(encoded, forKey: "watchList")
        }
        else {
            print("Error with encoding watchlist")
        }
    }
    
    func delete(at offsets: IndexSet) {
        watchList.stocks.remove(atOffsets: offsets)
    }
    
    
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}
