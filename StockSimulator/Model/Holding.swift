//
//  Holding.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/1/22.
//

import Foundation


struct Holding: Codable
{
    var id: Int // need to satisfy Codable
    
    var stock: Stock
    var amount: Double
    var purchasePrice: Double

}
