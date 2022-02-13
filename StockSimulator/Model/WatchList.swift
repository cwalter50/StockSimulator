//
//  WatchList.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/1/22.
//

import Foundation
import SwiftUI


struct WatchList: Codable
{
    var stocks: [Stock]
//    var id: Int // needed for Codeable
    
    init(stocks: [Stock])
    {
//        id = UUID().hashValue
        self.stocks = stocks
    }
}
