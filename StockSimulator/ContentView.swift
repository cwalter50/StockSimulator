//
//  ContentView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/29/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State var accounts: [Account]
    
    var body: some View {
        TabView {
            VStack {
                Text("Home Tab")
                Button(action: {
                    getChartData()
                    let timeStamps = ChartMockData.mockData.timestamp
                    
                    for t in timeStamps
                    {
                        let date = Date(timeIntervalSince1970: Double(t))
                        print(date)
                        
                    }
                }) {
                    Text("Load Chart Data")
                }

//                ChartView()
                ChartView(stockSnapshot: StockSnapshot())
                    .frame(width: 350, height: 300)
            }
            
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
         
            AccountsView()
//                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "bookmark.circle.fill")
                    Text("Accounts")
                }
         
            WatchlistsView()
//                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "video.circle.fill")
                    Text("WatchLists")
                }
         
            Text("Profile Tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
    
    func getChartData()
    {
//        stockSnapshots = []
//        stockSnapshot = nil // this is needed so STOCKVIEW Reloads after looking up a Stock...
        
        // remove all spaces from search symbol
        
        let searchSymbol = "F"
        let apiCaller = APICaller.shared
        apiCaller.getChartData(searchSymbol: searchSymbol, range: "1mo") {
            connectionResult in
            
            switch connectionResult {
            case .success(_):
                print("success")
            case .chartSuccess(_):
                print("chartSuccess")
            case .failure(_):
                print("failure")
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(accounts: [])
    }
}
