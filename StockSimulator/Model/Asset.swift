//
//  Asset.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import Foundation

// This is the asset that we are buying and currently hold
struct Asset: Codable, Identifiable
{
    var id: UUID // satisfies Identifiable and Codable for encoding and decoding
    
    var stock: Stock
    var amount: Double
    var purchasePrice: Double

}
