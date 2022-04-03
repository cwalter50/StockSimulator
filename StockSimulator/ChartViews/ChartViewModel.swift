//
//  ChartViewModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/28/22.
//

import Foundation
import SwiftUI

final class ChartViewModel: ObservableObject {
    @Published var chartData = ChartData() // this contains close, adjclose, volume, high, low, etc
    @Published var maxY: Double = 0.0
    @Published var minY: Double = 0.0
    @Published var medY: Double = 0.0
    @Published var q1: Double = 0.0
    @Published var q3: Double = 0.0
    @Published var lineColor: Color = Color.theme.red
    @Published var startingDate: Date = Date()
    @Published var endingDate: Date = Date()
    
    func loadData(symbol: String, range: String, completion: @escaping() -> Void ) {
        
////        let searchSymbol = "F"
//        let apiCaller = APICaller.shared
//        apiCaller.getChartData(searchSymbol: symbol, range: range) {
//            connectionResult in
//
//            switch connectionResult {
//            case .success(_):
//                print("success")
//                self.chartData = ChartData(emptyData: true)
//                completion()
//            case .chartSuccess(let theChartData):
//                print("chartSuccess")
//                print("loaded data for \(symbol) in the range \(range)")
//                DispatchQueue.main.async {
//                    self.loadData(from: theChartData)
//                }
//
//            case .failure(_):
//                print("failure")
//                self.chartData = ChartData(emptyData: true)
//                completion()
//            }
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.chartData = ChartMockData.mockData
            self.loadData(from: ChartMockData.mockData)
//            self.chartData = ChartMockData.oneMonth.normalized
            completion()
        }
    }
    
    
    func loadData(from chartData: ChartData)
    {
        self.chartData = chartData
        self.maxY = self.chartData.close.max() ?? 0
        self.minY = self.chartData.close.min() ?? 0
        self.medY = (self.maxY + self.minY) / 2
        self.q1 =  (self.medY + self.minY) / 2
        self.q3 = (self.maxY + self.medY) / 2
        
        let priceChange = (self.chartData.close.last ?? 0) - (self.chartData.close.first ?? 0)
        
        self.lineColor = priceChange > 0 ?  Color.theme.green : Color.theme.red
        
        let lastDateTimeInterval = TimeInterval(self.chartData.timestamp.last ?? 0)
        let firstDateTimeInterval = TimeInterval(self.chartData.timestamp.first ?? 0)
        self.endingDate = Date(timeIntervalSince1970: lastDateTimeInterval)
        self.startingDate = Date(timeIntervalSince1970: firstDateTimeInterval)
    }
}

