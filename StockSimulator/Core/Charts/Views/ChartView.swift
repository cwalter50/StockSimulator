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
    
    @State var currentPlot = ""
    @State var xShift: CGFloat = 100
    @State var yShift: CGFloat = 50
    @State var offset: CGSize = .zero
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
            let width = (gr.size.width) / CGFloat(vm.chartData.wrappedClose.count - 1)
            
            let points = getPoints(width: width, totalHeight: height-60)

            
            VStack {
                rangePicker
                ZStack {
                    linegraph
                        .background(chartBackground)

                        .overlay(chartYAxis.padding(.horizontal,4), alignment: .leading)
                        .overlay(alignment: .bottomLeading) {
                            DragIndicator(height: height, points: points)
                                .padding(.horizontal, 4)
                                .frame(width: 80, height: height - 60) // subtracting 60 to remove the rangepicker
//                                .opacity(showPlot ? 1 : 0)
//                                .background(Color.secondary.opacity(0.3))
                            
                                .offset(x: -40)
                                .offset(offset)
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
                            
                            let xShift = value.location.x
                            
                            self.index = max(min(Int((xShift / width).rounded()), vm.chartData.wrappedClose.count - 1), 0)
                            
                            offset = CGSize(width: points.count > 0 ? points[index].x: xShift, height: 0)

                            currentPlot =  vm.chartData.wrappedClose[index].asCurrencyWith2Decimals()
                        })
                        .onEnded({ value in
                            withAnimation {
                                showPlot = false
                            }
                            
                        })
                )
                chartDateLabels
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
    
    
    func loadData()
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
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
//        ChartView(stockSnapshot: StockSnapshot())
        
        ChartView(symbol: "AAPL")
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
        LineGraph(dataPoints: vm.chartData.wrappedClose.normalized)
        
//                LineGraph(dataPoints: ChartMockData.oneMonth.normalized)
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
    
    @ViewBuilder func DragIndicator(height: CGFloat, points: [CGPoint]) -> some View {
        VStack(spacing:0) {
            Spacer()
            Rectangle()
                .fill(Color.theme.secondaryText)
                .frame(width: 1, height: points.count > 0 ? max((height - points[index].y - 80), 0) : 100)

            Circle()
                .fill(Color.theme.secondaryText)
                .frame(width: 22, height: 22)

                .overlay(
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                            )
            Rectangle()
                .fill(Color.theme.secondaryText)
                .frame(width: 1, height: points.count > 0 ? points[index].y : 100)
            
        }
    }
    
    
    
    private func getPoints(width: CGFloat, totalHeight: CGFloat) -> [CGPoint] {
        var result = [CGPoint]()

        for i in vm.chartData.wrappedClose.normalized.indices {
            let x = width * CGFloat(i)
            let y = totalHeight * vm.chartData.wrappedClose.normalized[i]
//            print("Width: \(width), x: \(x)")
            result.append(CGPoint(x: x, y: y))
        }
        return result
    }
    
}
