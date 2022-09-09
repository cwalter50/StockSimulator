//
//  BarChartView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/27/22.
//

import SwiftUI

struct BarChartView: View {
//    @StateObject var vm: BarChartViewModel = BarChartViewModel()
    
    var data: [EarningsModel]
    var maxVal: Double
    var minVal: Double
    
    init(data: [EarningsModel])
    {
        self.data = data
        
        maxVal = max((data.map( { $0.actual ?? 0 }).max() ?? 0), (data.map( { $0.estimate ?? 0 }).max() ?? 0))
        minVal = min((data.map( { $0.actual ?? 0 }).min() ?? 0), data.map( { $0.estimate ?? 0 }).min() ?? 0)
//        vm.setData(chartData: data)
    }

    var body: some View {
        GeometryReader { gr in
            let detailHeight = 100.0
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(data) {
                        item in
                        VStack {
                            // Actual BarChart
                            HStack {
                                BarView(name: item.title, value: item.estimate ?? 0, maxValue: maxVal, minValue: minVal, totalHeight: gr.size.height - detailHeight, color: Color.theme.secondaryText)
                                BarView(name: item.title, value: item.actual ?? 0, maxValue: maxVal, minValue: minVal, totalHeight: gr.size.height - detailHeight, color: item.actual ?? 0 >= item.estimate ?? 0 ? Color.theme.green : Color.theme.red)
                            }.padding(.horizontal, 5)
                            // Bottom Titles and Stats
                            Text(item.title)
                                .font(.headline)
                                .fontWeight(.bold)
//                                .foregroundColor(Color.theme.secondaryText)
                            HStack(spacing: 5) {
                                StatisticView(stat: StatisticModel(title: "Estimation", value: (item.estimate ?? 0).formattedWithAbbreviations()))
                                Spacer()
                                StatisticView(stat: StatisticModel(title: "Actual", value: item.actual?.formattedWithAbbreviations() ?? "???", percentageChange: item.actual != nil ? (((item.actual ?? 0) - (item.estimate ?? 0))): nil, isPercentChange: false))
                                
                            }
                            .padding(.horizontal, 3)
//                            Text("Estimation:")
//                            StatisticView(stat: StatisticModel(title: item.title, value: (item.actual ?? 0).formattedWithAbbreviations()))
                        }
                    }
                }
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(data: dev.earningsData)
            .frame(width: 300, height: 300)
    }
}


