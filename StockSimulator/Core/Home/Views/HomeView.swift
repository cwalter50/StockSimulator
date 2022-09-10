//
//  HomeView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/13/22.
//

import SwiftUI

struct HomeView: View {
    
//    @EnvironmentObject var vm: StocksViewModel
    @EnvironmentObject var vm: MarketSummaryViewModel
//    @ObservedObject var vm = StocksViewModel()
    
    // needed to move navigationLink to background and not on the individual rows. When its on a row, it loads the data, before I need it. I prefer lazy loading, and only load the data when it is needed
    @State var selectedMarketSummary: MarketSummary? = nil
    @State var showDetailView = false
    
    @State private var showSettingView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        overviewHeader
                        Text("Here is where I will display market summary...")
                            .foregroundColor(Color.theme.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        snpHeader
                        snpStatsView
                        marketHeader
                        marketDataView
                    }
                }
                .padding()
            }
            .onAppear(perform: {
                vm.updateMarketData()
//                vm.updateMarketStats()
            })
            .navigationTitle(Text("Market Data"))

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshToolBarButton
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    CircleButton(iconName: "info")
                        .onTapGesture {
                            showSettingView.toggle()
                        }
                }
            }
            .sheet(isPresented: $showSettingView, content: {
                SettingsView()
            })
            .background {
                if let ms = selectedMarketSummary {
                    NavigationLink(destination: MarketSummaryView(marketSummary: ms), isActive: $showDetailView) {
                        EmptyView()
                    }
                }
                else {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(dev.marketsummaryVM)
//            .environmentObject(dev.stockVM)
    }
}

extension HomeView {
    private var refreshToolBarButton: some View {
        Button(action: {
            withAnimation(.linear(duration: 2.0)) {
                vm.updateMarketData()
            }
            HapticManager.notification(type: .success)
            print("Should load market data")
        }) {
            Image(systemName: "arrow.clockwise")
        }
        .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        
        
    }
    
    
    private var overviewHeader: some View {
        VStack {
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
        }
    }
    
    private var snpHeader: some View {
        VStack {
            Text("S&P Data")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
        }
    }
    private var marketHeader: some View {
        VStack {
            Text("Markets")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
        }
    }
    
    private var snpStatsView: some View {
        VStack (spacing: 2){
            ForEach(vm.snpMarketStats) {
                stat in
                StatisticRow(stat: stat)
            }
        }
    }
    
    private var marketDataView: some View {
        VStack {
            ForEach(vm.marketData, id: \.symbol) {
                item in
                VStack {
                    MarketSummaryRow(marketSummary: item)
                        .onTapGesture {
                            selectedMarketSummary = item
                            showDetailView.toggle()
                        }
                    Divider()
                }
            }
            
        }
    }
}
