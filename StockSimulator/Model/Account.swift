//
//  Account.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/1/22.
//

import Foundation

struct Account: Codable
{
    var id: Int
    
    var name: String
    var cash: Double
    var holdings: [Holding]
}
