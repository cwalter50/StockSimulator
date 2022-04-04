//
//  ChartView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/24/22.
//

import SwiftUI


struct ChartView: View {

    @ObservedObject var viewModel = ChartViewModel()
    
    @State private var animateChart = false
    @State private var showLoader = false
    
    @State private var trimValue: CGFloat = 0
    
    @State private var selectedTimeInterval = "1mo"
    
//    var timeRanges = ["1d","5d","1mo", "3mo","6mo","ytd","1y","2y","5y","10y","max"]
    var timeRanges = ["1d","5d","1mo","6mo","ytd","1y","max"]

    
    var stockSnapshot: StockSnapshot
    
    var body: some View {
        GeometryReader { gr in
            VStack {
                rangePicker
                ZStack {
                    linegraph
                        .background(chartBackground)
                        .overlay(chartYAxis.padding(.horizontal,4), alignment: .leading)
                        

                        .onAppear(perform: {
                            loadData()
                        })
                        

                    if showLoader {
                        ChartLoader()
                    }
                }
                chartDateLabels
                    .padding(.horizontal, 4)
            }
            .frame(width: gr.size.width, height: gr.size.height)
            .font(.caption)
            .foregroundColor(Color.theme.secondaryText)
        }
    }
    
    
    func loadData()
    {
        showLoader = true
        viewModel.chartData = ChartData(emptyData: true)
        animateChart = false
        trimValue = 0
        viewModel.loadData(symbol: stockSnapshot.symbol, range: selectedTimeInterval) {
            showLoader = false
            withAnimation(.easeInOut(duration: 2)) {
                animateChart = true
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(stockSnapshot: StockSnapshot())
            .frame(width: 350, height: 300)
    }
}

extension ChartView {
    
    private var rangePicker: some View {
        Picker("Time Interval", selection: $selectedTimeInterval) {
            ForEach(timeRanges, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onChange(of: selectedTimeInterval) { value in
            print("picker changed")
            // figure out how to reload the data if picker changes
            loadData()
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var linegraph: some View {
        LineGraph(dataPoints: viewModel.chartData.close.normalized)
        
//                LineGraph(dataPoints: ChartMockData.oneMonth.normalized)
            .trim(to: animateChart ? 1 : trimValue)
//                        .stroke(lineColor)
            .stroke(viewModel.lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: viewModel.lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: viewModel.lineColor.opacity(0.5), radius: 10, x: 0, y: 10)
            .shadow(color: viewModel.lineColor.opacity(0.2), radius: 10, x: 0, y: 10)
            .shadow(color: viewModel.lineColor.opacity(0.1), radius: 10, x: 0, y: 10)
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(viewModel.startingDate.asShortDateString())
            Spacer()
            Text(viewModel.endingDate.asShortDateString())
        }
    }
    

    
    private var chartYAxis: some View {
        VStack {
            Text("\(viewModel.maxY.formattedWithAbbreviations())")
            Spacer()
            Text("\(viewModel.q3.formattedWithAbbreviations())")
            Spacer()
            Text("\(viewModel.medY.formattedWithAbbreviations())")
            Spacer()
            Text("\(viewModel.q1.formattedWithAbbreviations())")
            Spacer()
            Text("\(viewModel.minY.formattedWithAbbreviations())")
        }
    }
    
}
