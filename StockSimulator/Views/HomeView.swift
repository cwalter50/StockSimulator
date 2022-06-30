//
//  HomeView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/13/22.
//

import SwiftUI

struct HomeView: View {
    
//    @EnvironmentObject var vm: StocksViewModel
    @ObservedObject var vm = StocksViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    loadChartData(symbol: "AAPL", range: "max")
                }) {
                    Text("Test Chart Data")
                }
                List{
                    ForEach(vm.marketData, id: \.symbol) {
    //                ForEach(vm.marketData) {
                        item in
                        NavigationLink(destination: MarketSummaryView(marketSummary: item)) {
                            MarketSummaryRow(marketSummary: item)
                        }
                    }
                }

            }
            .onAppear(perform: {
                vm.updateMarketData()
            })
            .navigationTitle(Text("Market Data"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        vm.updateMarketData()
                        print("Should load market data")
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
    
    
    
    func loadChartData(symbol: String, range: String)
    {
        let apiCaller = APICaller.shared
        apiCaller.getChartData2(searchSymbol: symbol, range: range) {
            connectionResult in

            switch connectionResult {
                case .chartSuccess(let theChartData):
                    print("loaded data for \(symbol) in the range \(range)")
//                    print(theChartData)
                    DispatchQueue.main.async {
//                        self.setData(from: theChartData)
                        
                    }
//                    completion(.success(theChartData))
                case .failure(let errorMessage):
                    print("failure loading chart data")
                DispatchQueue.main.async {
//                    self.chartData = ChartData(emptyData: true)
//                    completion(.failure(errorMessage))
                }
                    
                    
                default:
                    print("loading chart data was not a success or failure")
//                    self.chartData = ChartData(emptyData: true)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
