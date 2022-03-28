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

final class ChartViewModel: ObservableObject {
    @Published var chartData = [Double]()
    
    func loadData(symbol: String, completion: @escaping() -> Void ) {
        
////        let searchSymbol = "F"
//        let apiCaller = APICaller.shared
//        apiCaller.getChartData(searchSymbol: symbol) {
//            connectionResult in
//            
//            switch connectionResult {
//            case .success(_):
//                print("success")
//                self.chartData = []
//                completion()
//            case .chartSuccess(let theChartData):
//                print("chartSuccess")
//                
//                DispatchQueue.main.async {
//                    self.chartData = theChartData.close.normalized
//                    completion()
//                }
//                
//            case .failure(_):
//                print("failure")
//                self.chartData = []
//                completion()
//            }
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.chartData = ChartMockData.oneMonth.normalized
            completion()
        }
    }
}

struct ChartView: View {

    @ObservedObject var viewModel = ChartViewModel()
    
    @State private var animateChart = false
    @State private var showLoader = false
    
    @State private var selectedTimeInterval = "1mo"
    
//    var timeRanges = ["1d","5d","1mo", "3mo","6mo","ytd","1y","2y","5y","10y","max"]
    var timeRanges = ["1d","5d","1mo","6mo","ytd","1y","max"]

    
    var stockSnapshot: StockSnapshot
    
    var body: some View {
        VStack {
            Picker("Time Interval", selection: $selectedTimeInterval) {
                ForEach(timeRanges, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedTimeInterval) { value in
                print("picker changed")
                // figure out how to reload the data if picker changes

            }
            ZStack {
//                LineGraph(dataPoints: viewModel.chartData)
                LineGraph(dataPoints: ChartMockData.oneMonth.normalized)
                    .trim(to: animateChart ? 1 : 0)
                    .stroke(Color.blue)
        //            .border(Color.black)
                    .frame(width: 350, height: 300)
                    .onAppear(perform: {
                        showLoader = true
                        viewModel.loadData(symbol: stockSnapshot.symbol) {
                            showLoader = false
                            withAnimation(.easeInOut(duration: 2)) {
                                animateChart = true
                            }
                        }
                        
                    })
                if showLoader {
                    ChartLoader()
                }
                
            }
        }


    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(stockSnapshot: StockSnapshot())
    }
}
