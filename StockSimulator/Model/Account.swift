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
    var holdings: [Holding]
    
    init ()
    {
        id = UUID()
        name = "Test"
        cash = 10000
        holdings = []
    }
    
    init (name: String, cash: Double)
    {
        self.name = name
        self.cash = cash
        self.holdings = []
        id = UUID()
    }
}
