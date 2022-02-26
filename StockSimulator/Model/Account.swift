//
//  Account.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/1/22.
//

import Foundation

class Account: ObservableObject, Codable, Identifiable
{
    var id: UUID
    
    var name: String
    var cash: Double
    var assets: [Asset]
    var startingValue: Double
    
    
    init ()
    {
        id = UUID()
        name = "Test"
        cash = 10000
        assets = []
        startingValue = 10000
    }
    
    init (name: String, cash: Double)
    {
        self.name = name
        self.cash = cash
        self.assets = []
        id = UUID()
        startingValue = cash
    }
    
    func calculateValue() -> Double
    {
        var total = cash
        for asset in assets {
            total += asset.amount + asset.stock.regularMarketPrice * asset.amount
        }
        
        return total
        
    }
    
    func calculatePercentChange() -> String
    {
        let currentValue = calculateValue()
        if currentValue >= startingValue
        {
            let growth = (currentValue / startingValue - 1) * 100
            return String(format: "+%.1f", growth)
        }
        else
        {
            let growth = (1 - currentValue / startingValue) * 100
            return String(format: "-%.1f", growth)
        }
    }
    
}
