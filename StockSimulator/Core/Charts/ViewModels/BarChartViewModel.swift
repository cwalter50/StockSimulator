//
//  BarChartViewModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/27/22.
//

import Foundation
import SwiftUI


final class BarChartViewModel: ObservableObject {
    @Published var chartData: [EarningsModel] = []
    
    func setData(chartData: [EarningsModel])
    {
        self.chartData = chartData
    }
}
