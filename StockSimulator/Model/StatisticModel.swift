//
//  StatisticModel.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/24/22.
//

import Foundation

struct StatisticModel: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    let isPercentChange: Bool? // I added this so that I can reuse the view, with a percent sign or without one. ie can see -12.56 or -12.56%
    
    // this will make 2 constructors in one. One constructor has two parameters, the other one has all 3 parameters.
    init(title: String, value: String, percentageChange: Double? = nil, isPercentChange: Bool? = nil)
    {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
        self.isPercentChange = isPercentChange
    }
    
}

