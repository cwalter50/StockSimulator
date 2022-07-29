//
//  StockDetailView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/25/22.
//

import SwiftUI

struct StockDetailView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    @ObservedObject var stock: Stock
    
//    private let additionalInfo: [StatisticModel]
    
    @StateObject var vm: StockDetailViewModel
//    @ObservedObject var vm: StockDetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(stock: Stock)
    {
        // load most recent data for stock
        self.stock = stock
        
        
        _vm = StateObject(wrappedValue: StockDetailViewModel(stock: stock))
//        vm = StockDetailViewModel(stock: stock)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                StockBasicView(stockSnapshot: StockSnapshot(stock: stock))
                Divider()
                ChartView(symbol: vm.stock.wrappedSymbol)
                    .frame(height: 300)
                Text("Overview")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: nil,
                    pinnedViews: [],
                    content: {
                        ForEach(vm.overviewStatistics) { stat in
                            StatisticView(stat: stat)

                        }
                })
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                print("HI")
                    vm.reloadStockData()
//                    loadCurrentStockInfo()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    func loadCurrentStockInfo()
    {
        
        let apiCaller = APICaller.shared
        apiCaller.getQuoteData(searchSymbols: stock.wrappedSymbol) {
            connectionResult in
            switch connectionResult {
                case .success(let theStocks):
                    // link the stocks to the current stock prices, update the values,
                if let foundStock = theStocks.first(where: { $0.symbol.uppercased() == self.stock.wrappedSymbol.uppercased() }) {
                    DispatchQueue.main.async {
                        
                        self.stock.updateValuesFromStockSnapshot(snapshot: foundStock)
                        try? moc.save()
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

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stock: dev.sampleStock)
        }
        .navigationViewStyle(.stack)
        
    }
}
