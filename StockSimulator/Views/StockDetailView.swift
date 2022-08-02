//
//  StockDetailView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/25/22.
//

import SwiftUI

struct StockDetailView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
//    @ObservedObject var stock: Stock
    
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
//        self.stock = stock
        _vm = StateObject(wrappedValue: StockDetailViewModel(stockSnapshot: StockSnapshot(stock: stock)))
//        vm = StockDetailViewModel(stock: stock)
    }
    
    init(symbol: String) {
        _vm = StateObject(wrappedValue: StockDetailViewModel(symbol: symbol))
    }
    
    var body: some View {
        ZStack {

            ScrollView {
                VStack {
                    topDetailView
                    Divider()
                    ChartView(symbol: vm.symbol)
                        .frame(height: 300)
                    overViewHeader
                    Divider()
                    overviewStatsGrid
                    stockRecommendationsHeader
                    Divider()
                    stockRecommendationsSliderView
                }
                Spacer()
                .padding()
            }
        }
        
        .navigationTitle(vm.stockSnapshot == nil ? "\(vm.symbol)" :"\(vm.stockSnapshot?.wrappedDisplayName ?? "")")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                print("HI")
                    vm.reloadStockData(symbol: vm.symbol, moc: moc)
                }) {
                    Image(systemName: "arrow.clockwise")
                }
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

extension StockDetailView {
    
    private var topDetailView: some View {
        VStack {
            if let stockSnapshot = vm.stockSnapshot {
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
                }
            }
            else {
                EmptyView()
            }
            
            
        }
    }
    var overViewHeader: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var overviewStatsGrid: some View {
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
    }
    
    var stockRecommendationsHeader: some View {
        Text("Stock Recomendations")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var stockRecommendationsSliderView: some View {
        ScrollView(.horizontal)
        {
            HStack(spacing: 10) {
                ForEach(vm.stockRecommendations) { rec in

                    NavigationLink(destination: StockDetailView(symbol: rec.symbol)) {
                        VStack(alignment: .center) {
                            Text(rec.symbol)
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Text("\(rec.score.asDecimalWith6Decimals())")
                                .font(.body)
                                .foregroundColor(Color.white)
                        }
                        .padding(4)
                        .background(Color.theme.buttonColor)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}
