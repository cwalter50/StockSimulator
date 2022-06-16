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
        VStack {
            Text("Hello")
            Button(action: {
//                APICaller.shared.getMarketData()
                vm.updateMarketData()
                print("SHould load market data")
            }) {
                Text("GetMarketData")
            }
            List{
                ForEach(vm.marketData, id: \.symbol) {
                    item in
                    Text(item.fullExchangeName)
                }
            }

        }
        .onAppear(perform: {
            vm.updateMarketData()
        })
        
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
