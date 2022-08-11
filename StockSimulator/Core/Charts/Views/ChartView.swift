//
//  ChartView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/24/22.
//

import SwiftUI

struct ChartView: View {
    
//    @ObservedObject var vm = ChartViewModel()
    @StateObject var vm: ChartViewModel = ChartViewModel()
    
    @State private var animateChart = false
    @State private var showLoader = false
    @State private var trimValue: CGFloat = 0
    
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    @State private var selectedTimeInterval = "1mo"
    
    // Indicator Stats
    @State var currentDateTime = ""
    @State var currentClose = ""
    @State var currentVolume = ""
    
    @State var offset: CGSize = .zero // this is the offset of the ball on the indicator bar from the bottom left corner of the chart
    @State var showPlot = false
    @State var translation: CGFloat = 0
    @State var index: Int = 0
    
    
    var timeRanges = ["1d","5d","1mo","6mo","ytd","1y","max"]

    var symbol: String
    
    init(symbol: String)
    {
        // have to convert symbol into a new form. the when the symbol is ^DJI -> %5EDJI. I do not know why, but I need to convert it to make it work with the API. also CL=F -> CL%3DF
        if symbol.contains("^") {
            let result = symbol.replacingOccurrences(of: "^", with: "%5E")
            self.symbol = result
        }
        else if symbol.contains("=") {
            let result = symbol.replacingOccurrences(of: "=", with: "%3D")
            self.symbol = result
        }
        else {
            self.symbol = symbol
        }

    }
    
    var body: some View {
        GeometryReader { gr in
            let height = gr.size.height
            let width = (gr.size.width) / CGFloat(vm.closeData.count - 1)
            let points = getPoints(width: width, totalHeight: height - 90) // subtracting 90 to remove the rangepicker, barChart, and dateLabels
            
            VStack {
                rangePicker
                ZStack {
                    linegraph
                        .background(chartBackground)
                        .overlay(chartYAxis.padding(.horizontal,4).foregroundColor(Color.theme.secondaryText), alignment: .leading)
                        .overlay(alignment: .bottomLeading) {
                            DragIndicator(height: height, points: points)
                                .padding(.horizontal, 4)
                                .frame(width: 80, height: height - 90) // subtracting 90 to remove the rangepicker, barChart, and dateLabels
                                .offset(x: -40)
                                .offset(offset)
                                .opacity(showPlot ? 1 : 0)
//                                .background(Color.gray.opacity(0.5))
                            
                        }
                        .overlay(alignment: .bottomLeading) {
                            indicatorStats
                                .frame(width: 150, height: height - 90, alignment: .center) // subtracting 90 to remove the rangepicker, barChart, and dateLabels
//                                .offset(x: -40)
                                .offset(CGSize(width: index > (vm.closeData.count / 2) ? offset.width - 160: offset.width + 10, height: offset.height ))
                                .opacity(showPlot ? 1 : 0)
                        }
                        .onAppear(perform: {
                            loadData()
                        })
                    if showLoader {
                        ChartLoader()
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            withAnimation {
                                showPlot = true
                            }
                            updateDragIndactorData(value: value, width: width, points: points)
                        })
                        .onEnded({ value in
                            withAnimation {
                                showPlot = false
                            }
                            
                        })
                )
                volumeBarChart(width: width)
                
                chartDateLabels
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.horizontal, 4)
            }
            .frame(width: gr.size.width, height: gr.size.height)
            .font(.caption)
            .foregroundColor(Color.theme.secondaryText)
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Error"), message: Text("\(errorMessage)"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
//        ChartView(stockSnapshot: StockSnapshot())
        
        ChartView(symbol: "AAPL")
            .frame(width: 350, height: 300)
            .preferredColorScheme(.dark)
            
    }
}

extension ChartView {
    
    private func loadData()
    {
        showLoader = true
        animateChart = false
        trimValue = 0
        vm.loadData(symbol: symbol, range: selectedTimeInterval) {
            chartDataResult in
            switch chartDataResult {
            case .success(_):
                showLoader = false
                withAnimation(.easeInOut(duration: 2)) {
                    animateChart = true
                }
            case .failure(let error):
                errorMessage = error
                showingErrorAlert = true
                showLoader = false
            }
        }
    }
    
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
        LineGraph(dataPoints: vm.closeDataNormalized)
            .trim(to: animateChart ? 1 : trimValue)
//                        .stroke(lineColor)
            .stroke(vm.lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: vm.lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: vm.lineColor.opacity(0.5), radius: 10, x: 0, y: 10)
            .shadow(color: vm.lineColor.opacity(0.2), radius: 10, x: 0, y: 10)
            .shadow(color: vm.lineColor.opacity(0.1), radius: 10, x: 0, y: 10)
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(vm.startingDate.asShortDateString())
            Spacer()
            Text(vm.endingDate.asShortDateString())
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text("\(vm.maxY.formattedWithAbbreviations())")
            Spacer()
            Text("\(vm.q3.formattedWithAbbreviations())")
            Spacer()
            Text("\(vm.medY.formattedWithAbbreviations())")
            Spacer()
            Text("\(vm.q1.formattedWithAbbreviations())")
            Spacer()
            Text("\(vm.minY.formattedWithAbbreviations())")
        }
    }
    
    private var indicatorStats: some View {
        VStack {
            HStack{
                Text("Date/Time:")
                    .fontWeight(.semibold)
                Spacer()
                Text(currentDateTime)
            }
            HStack {
                Text("Close:")
                    .fontWeight(.semibold)
                Spacer()
                Text(currentClose)
            }
            HStack {
                Text("Volume:")
                    .fontWeight(.semibold)
                Spacer()
                Text(currentVolume)
            }
        }
        .font(.caption2)
        .padding(6)
        .foregroundColor(Color.white)
        .background(
            Rectangle()
                .fill(Color.gray.opacity(0.6))
                .cornerRadius(10)
                .shadow(color: Color.gray, radius: 5, x: 0.3, y: 0.3)
        )
    }
    
    func updateDragIndactorData(value: DragGesture.Value, width: CGFloat, points: [CGPoint]) {
        let xShift = value.location.x
        
        self.index = max(min(Int((xShift / width).rounded()), vm.closeData.count - 1), 0)
        
        offset = CGSize(width: points.count > 0 ? points[index].x: xShift, height: 0)

        if index < vm.closeData.count {
            currentClose =  vm.closeData[index].asCurrencyWith2Decimals()
            currentVolume = "\(vm.chartData.wrappedvolume[index])"
            if selectedTimeInterval == "1d" || selectedTimeInterval == "5d" {
                currentDateTime =  Date(timeIntervalSince1970: Double(vm.chartData.timestamp[index])).asShortDateAndTimeString()
            } else {
                currentDateTime = Date(timeIntervalSince1970: Double(vm.chartData.timestamp[index])).asShortDateString()
            }
        }
    }
    
    @ViewBuilder func DragIndicator(height: CGFloat, points: [CGPoint]) -> some View {
        VStack(spacing:0) {
            Spacer()
            Rectangle()
                .fill(Color.theme.yellow)
                .frame(width: 1, height: points.count > 0 ? max((height - points[index].y - 105), 0) : 20)

            Circle()
                .fill(Color.theme.yellow)
                .frame(width: 22, height: 22)

                .overlay(
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                            )
            Rectangle()
                .fill(Color.theme.yellow)
                .frame(width: 1, height: points.count > 0 ? points[index].y : 100)
        }
    }
    
    @ViewBuilder func volumeBarChart(width: CGFloat) -> some View {
        let maxVolume = vm.chartData.wrappedvolume.max() ?? 0
        
        HStack(alignment: .bottom,spacing: width - 2) {
            ForEach(0..<vm.chartData.wrappedvolume.count, id: \.self) { i in
                Rectangle()
                    .fill(i >= 1 && vm.closeData[i] < vm.closeData[i-1] ? Color.theme.red : Color.theme.green)
                    .frame(width: 2, height: CGFloat(25 * vm.chartData.wrappedvolume[i] / maxVolume))
                
            }
        }
    }
    
    
    private func getPoints(width: CGFloat, totalHeight: CGFloat) -> [CGPoint] {
        var result = [CGPoint]()

        for i in vm.closeDataNormalized.indices {
            let x = width * CGFloat(i)
            let y = totalHeight * vm.closeDataNormalized[i]
//            print("Width: \(width), x: \(x)")
            result.append(CGPoint(x: x, y: y))
        }
        return result
    }
    
}
