//
//  Codable.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/27/22.
//

import Foundation


extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
