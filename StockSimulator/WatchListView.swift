//
//  WatchListView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/1/22.
//

import SwiftUI

struct WatchListView: View {
    var watchList: WatchList
    

    init() {
        if let data = UserDefaults.standard.data(forKey: "watchList") {
            if let decoded = try? JSONDecoder().decode(WatchList.self, from: data) {
                watchList = decoded
                return
            }
        }

        watchList = WatchList(stocks: [])
    }
    
    
//    var investments: [Investment]
    var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .leading) {
                    Text("Simon Ng")
                    Text("Founder of AppCoda")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                }
            }
            
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
    
    
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}
