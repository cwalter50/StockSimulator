//
//  StockSearchView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/12/22.
//

import SwiftUI

struct StockSearchView: View {
    
    @ObservedObject var watchList: WatchList
    
    
    @State var searchSymbol: String = ""
//    @State var foundStock: Bool = false
    @State var stock: Stock?
    
    // will all ow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    init()
    {
        self.watchList = WatchList() // this will load the stocks from UserDefaults...
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("StockSymbol", text: $searchSymbol, prompt: Text("Enter Stock Symbol"))
                    .autocapitalization(.allCharacters)
                
                Button(action: getStockData) {
                    Text("Search")
                }
                
            }
            .padding()
            if stock != nil
            {
                StockView(stock: stock!)
                
                Button(action: {
                    if let foundStock = stock {
                        watchList.stocks.append(foundStock)
//                        watchList.saveToUserDefaults()
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add to WatchList")
                }
                HStack {
                    Button(action: {
                        // Remove From Account
                    }) {
                        Text("SELL")
                    }
                    Button(action: {
                        // Add to Account
                    }) {
                        Text("BUY")
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
    
    func getStockData()
    {
        let apiCaller = APICaller.shared
        apiCaller.getAllStockData(searchSymbol: searchSymbol) {
            connectionResult in
            
            switch connectionResult {
                case .success(let theStock):
                    stock = theStock
                case .failure(let error):
                    print(error)
                    stock = nil
            }
        }
        
    }
}

struct StockSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StockSearchView()
    }
}
