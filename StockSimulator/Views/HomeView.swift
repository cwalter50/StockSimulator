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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
