//
//  ChartViewModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/28/22.
//

import Foundation
import SwiftUI

enum ChartDataResult {
    case success(ChartData)
    case failure(String)
}

final class ChartViewModel: ObservableObject {
//    @Published var chartData: ChartData
    @Published var chartData: ChartData = ChartData(emptyData: true) // this contains close, adjclose, volume, high, low, etc
    @Published var maxY: Double = 0.0
    @Published var minY: Double = 0.0
    @Published var medY: Double = 0.0
    @Published var q1: Double = 0.0
    @Published var q3: Double = 0.0
    @Published var lineColor: Color = Color.theme.green
    @Published var startingDate: Date = Date()
    @Published var endingDate: Date = Date()
    
    func loadData(symbol: String, range: String, completion: @escaping(ChartDataResult) -> Void ) {
        
        let apiCaller = APICaller.shared
        apiCaller.getChartData(searchSymbol: symbol, range: range) {
            connectionResult in

            switch connectionResult {
                case .chartSuccess(let theChartData):
                    print("loaded data for \(symbol) in the range \(range)")
    //                print(theChartData)
                    DispatchQueue.main.async {
                        self.setData(from: theChartData)
                    }
                    completion(.success(theChartData))
                case .failure(let errorMessage):
                    print("failure loading chart data")
                    DispatchQueue.main.async {
                        self.chartData = ChartData(emptyData: true)
                        completion(.failure(errorMessage))
                    }
                default:
                    print("loading chart data was not a success or failure")
                    self.chartData = ChartData(emptyData: true)
            }
        }
    }
    
    
    func setData(from chartData: ChartData)
    {
        self.chartData = chartData
        self.maxY = getMaxY()
//        self.maxY = self.chartData.close.max() ?? 0
//        self.minY = self.chartData.close.min() ?? 0
        self.minY = getMinY()
        self.medY = (self.maxY + self.minY) / 2
        self.q1 =  (self.medY + self.minY) / 2
        self.q3 = (self.maxY + self.medY) / 2
        
        if let last = self.chartData.close.last ?? 0, let first = self.chartData.close.first ?? 0 {
            let priceChange = last - first
            self.lineColor = priceChange >= 0 ?  Color.theme.green : Color.theme.red
        }
        else {
            lineColor = Color.theme.green
        }

        let lastDateTimeInterval = TimeInterval(self.chartData.timestamp.last ?? 0)
        let firstDateTimeInterval = TimeInterval(self.chartData.timestamp.first ?? 0)
        self.endingDate = Date(timeIntervalSince1970: lastDateTimeInterval)
        self.startingDate = Date(timeIntervalSince1970: firstDateTimeInterval)
    }
    
    private func getMaxY() -> Double {
        var max = -10000000.0
        for i in chartData.close {
            if let val = i {
                if val > max {
                    max = val
                }
            }
        }
        return max
    }
    private func getMinY() -> Double {
        var min = 100000000.0
        for i in chartData.close {
            if let val = i {
                if val < min {
                    min = val
                }
            }
        }
        return min
    }
}

