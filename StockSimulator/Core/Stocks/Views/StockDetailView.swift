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
    
    @State private var showFullDescription: Bool = false
    
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
                    stockRatingView
                    ChartView(symbol: vm.symbol)
                        .frame(height: 300)
//                    descriptionHeader
                    descriptionSection
                    overviewSection
                    earningsSection
                    stockRecommendationsHeader
                    Divider()
                    stockRecommendationsSliderView
                    websiteLinkView
                }
                .padding()
                Spacer()
                .padding()
            }
        }
        .navigationTitle(vm.stockSnapshot == nil ? "\(vm.symbol)" :"\(vm.stockSnapshot?.wrappedDisplayName ?? "")")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                print("HI")
                    vm.reloadStockData(symbol: vm.symbol)
                    HapticManager.notification(type: .success)
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
    
    private var stockRatingView: some View {
        VStack {
            HStack {
                Text("Stock Rating")
                Spacer()
                Text("\(vm.stockRating.asDecimalWith2Decimals())")
                    .foregroundColor(vm.stockRating >= 70 ? Color.theme.green : Color.theme.red)
            }
            .font(.title2)
        }
    }
    
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
            Divider()
        }
    }
    

    
    private var descriptionSection: some View {
        VStack {
            Text("Description")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            ZStack {
                if let quoteSummary = vm.quoteSummary, let assetProfile = quoteSummary.assetProfile {
                    VStack(alignment: .leading) {
                        Text(assetProfile.wrappedDescription)
                            .lineLimit(showFullDescription ? nil : 3)
                            .font(.callout)
                            .foregroundColor(Color.theme.secondaryText)
                        Button {
                            withAnimation(.easeInOut) {
                                showFullDescription.toggle()
                                
                            }
                        } label: {
                            Text(showFullDescription ? "See Less" : "Read more..." )
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.vertical, 4)
                        }
                        .accentColor(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        
    }
    
    var overviewSection: some View {
        VStack {
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
            .padding(.horizontal, 5)
        }
    }
    
    var earningsSection: some View {
        VStack {
            Text("Earnings")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            BarChartView(data: vm.earningsStatistics)
                .frame(height: vm.earningsStatistics.count > 0 ? 200: 0, alignment: .center)
//                .padding(.bottom, 40)
        }
    }
    
    var stockRecommendationsHeader: some View {
        Text("Stock Recomendations")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var websiteLinkView: some View {
        ZStack(alignment: .leading) {
            if let summary = vm.quoteSummary, let assetProfile = summary.assetProfile, let urlString = assetProfile.website, let url = URL(string: urlString) {
                Link(destination: url) {
                    Text("Website: \(urlString)")
                        .font(.headline)
                        .foregroundColor(Color.blue)
                        .padding()
                }
            }
        }
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
