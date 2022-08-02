//
//  StockRecomendations.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/1/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(StockReccomendations.self, from: jsonData)

import Foundation

// MARK: - StockReccomendations
struct StockReccomendations: Codable {
    let finance: Finance
}

// MARK: - Finance
struct Finance: Codable {
    let error: JSONNull?
    let result: [Recommendation]
}

// MARK: - Result
struct Recommendation: Codable {
    let recommendedSymbols: [RecommendedSymbol]
    let symbol: String
}

// MARK: - RecommendedSymbol
struct RecommendedSymbol: Codable, Identifiable {
    let score: Double
    let symbol: String
    var id: UUID {
        return UUID()
    }
}



// MARK: Sample Response
/*
 {
   "finance": {
     "result": [
       {
         "symbol": "PYPL",
         "recommendedSymbols": [
           {
             "symbol": "SQ",
             "score": 0.228741
           },
           {
             "symbol": "NVDA",
             "score": 0.162863
           },
           {
             "symbol": "V",
             "score": 0.15888
           },
           {
             "symbol": "SHOP",
             "score": 0.158117
           },
           {
             "symbol": "CRM",
             "score": 0.154448
           }
         ]
       }
     ],
     "error": null
   }
 }
 
 */

