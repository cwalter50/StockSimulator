//
//  ChartViewModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/28/22.
//

import Foundation
import SwiftUI

final class ChartViewModel: ObservableObject {
    @Published var chartData = [Double]()
    
    func loadData(symbol: String, range: String, completion: @escaping() -> Void ) {
        
////        let searchSymbol = "F"
        let apiCaller = APICaller.shared
        apiCaller.getChartData(searchSymbol: symbol, range: range) {
            connectionResult in

            switch connectionResult {
            case .success(_):
                print("success")
                self.chartData = []
                completion()
            case .chartSuccess(let theChartData):
                print("chartSuccess")
                print("loaded data for \(symbol) in the range \(range)")
                DispatchQueue.main.async {
                    self.chartData = theChartData.close.normalized
                    completion()
                }

            case .failure(_):
                print("failure")
                self.chartData = []
                completion()
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.chartData = ChartMockData.oneMonth.normalized
//            completion()
//        }
    }
}

