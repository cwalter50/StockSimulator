//
//  StockView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/29/22.
//

import SwiftUI

struct StockBasicView: View {
    
//    @State var stockSnapshot: StockSnapshot? = nil
    @State var stockSnapshot: StockSnapshot

    var body: some View {
        VStack {
            HStack (alignment: .firstTextBaseline){
                VStack(alignment: .leading){
                    Text(stockSnapshot.symbol)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(stockSnapshot.wrappedDisplayName)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Text(String(format: "$%.2f", stockSnapshot.regularMarketPrice))
                        .font(.title)
                    HStack {
                        Text(stockSnapshot.regularMarketChangeFormatted)
                        
                        Text(stockSnapshot.regularMarketChangePercentFormatted)
                    }
                    .foregroundColor(stockSnapshot.regularMarketChange >= 0 ? Color.theme.green : Color.theme.red)
                    .font(.headline)
                }
                .onAppear(perform: loadCurrentStockInfo)
            }
            
        }
        
    }
    
    func loadCurrentStockInfo()
    {
        print("on appear called in stockBasicView")
        let searchString = stockSnapshot.symbol
        
        let apiCaller = APICaller.shared
        apiCaller.getQuoteData(searchSymbols: searchString.uppercased()) {
            connectionResult in
            
            switch connectionResult {
                case .success(let theStocks):
                    // link the stocks to the current stock prices, update the values,
                    for snapshot in theStocks
                    {
                        if snapshot.symbol == stockSnapshot.symbol {
                            self.stockSnapshot = snapshot
                            print("stock price is \(snapshot.regularMarketPrice)")
                        }
                    }
                case .failure(let error):
                    print(error)
                
                default:
                    print("ConnectionResult is not success or failure")

            }
        }
    }
}


struct StockBasicView_Previews: PreviewProvider {
    static var previews: some View {
        StockBasicView(stockSnapshot: StockSnapshot())
        
    }
}
