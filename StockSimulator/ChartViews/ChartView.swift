//
//  ChartView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/24/22.
//

import SwiftUI


struct ChartLoader: View {
    private let animation = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
    
    @State var isAtMaxScale = false
    
    private let maxScale: CGFloat = 1.5
    var body: some View {
        VStack{
            Text("Loading")
                .font(.custom("Avenir", size: 16))
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.blue)
                .frame(width: UIScreen.main.bounds.width/2, height: 3)
                .scaleEffect(CGSize(width: isAtMaxScale ? maxScale: 0.01, height: 1.0))
                .onAppear(perform: {
                    withAnimation(animation) {
                        self.isAtMaxScale.toggle()
                    }
                })
        }
    }
}


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
                    LineGraph(dataPoints: viewModel.chartData)
    //                LineGraph(dataPoints: ChartMockData.oneMonth.normalized)
                        .trim(to: animateChart ? 1 : trimValue)
                        .stroke(Color.blue)
                        .background(chartBackground)
                        .frame(width: gr.size.width, height: gr.size.height)
                        .onAppear(perform: {
                            loadData()
                        })
                    if showLoader {
                        ChartLoader()
                    }
                }
            }
        }
    }
    
    
    func loadData()
    {
        showLoader = true
        viewModel.chartData = []
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
    

    
//    private var chartYAxis: some View {
//        VStack {
//            Text("\(maxY)")
//            Spacer()
//            Text("\(q3)")
//            Spacer()
//            Text("\(medY)")
//            Spacer()
//            Text("\(q1)")
//            Spacer()
//            Text("\(minY)")
//        }
//    }
    
}
