//
//  StockSearchView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/12/22.
//

import SwiftUI

struct StockSearchView: View {
    @State var searchSymbol: String = ""
//    @State var foundStock: Bool = false
    @State var stock: Stock?
    
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
                Text(stock!.symbol)
                Text(String(format: "$%.2f", stock!.regularMarketPrice))
                
                Button(action: {
                    
                }) {
                    Text("Add to WatchList")
                }
            }
        }
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
