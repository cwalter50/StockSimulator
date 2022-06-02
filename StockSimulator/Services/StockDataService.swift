//
//  StockDataService.swift
//  StockSimulator
//
//  Created by Christopher Walter on 4/24/22.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class StockDataService: ObservableObject {
    
    @Published var stockSnapshots: [StockSnapshot] = []
    

    @Environment(\.managedObjectContext) var moc
    
    var stockSubscription: AnyCancellable?
    init() {
//        getQuoteData(searchSymbols: "")
    }

    func updateStockData(searchSymbols: String, stocks: FetchedResults<Stock>)
    {
        let urlString = Constants.quoteurlString + searchSymbols.uppercased()
//        let urlString = Constants.quoteurlString + "AAPL"
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["x-api-key": Constants.apiKey]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            guard let data = data else { return }
            do {
                guard let results =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                    print("error in getting JSON")
                    return
                }
                if let message = results["message"] as? String
                {
                    print(message)
//                    completion(.failure(message))
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: results)
//                    print(json)
                    let decoder = JSONDecoder()
                    let quoteSnapshot = try decoder.decode(QuoteSnapshot.self, from: json)
                    print(quoteSnapshot)
                    self.stockSnapshots = quoteSnapshot.quoteResponse.result
//                    print("Found these stocks: \(self.stockSnapshots)")
                    
                    // update Stock prices in CoreData
                    for snapshot in self.stockSnapshots {
                        if let stockCoreData = stocks.first(where: {$0.symbol == snapshot.symbol}) {
                            stockCoreData.updateValuesFromStockSnapshot(snapshot: snapshot)

                            print("updated values for \(stockCoreData.wrappedSymbol)")
                        }
                        
                    }
                    try? self.moc.save()

//                    completion(.success(quoteSnapshot.quoteResponse.result))
                }
                catch {
                    print(error)
//                    completion(.failure(error.localizedDescription))
                }
            }
            catch {
                print(error)
//                completion(.failure(error.localizedDescription))
            }
        }
        task.resume()
    }
    
    func getQuoteData(searchSymbols: String)
    {
        let urlString = Constants.quoteurlString + searchSymbols.uppercased()
//        let urlString = Constants.quoteurlString + "AAPL"
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["x-api-key": Constants.apiKey]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            guard let data = data else { return }
            do {
                guard let results =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                    print("error in getting JSON")
                    return
                }
                if let message = results["message"] as? String
                {
                    print(message)
//                    completion(.failure(message))
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: results)
//                    print(json)
                    let decoder = JSONDecoder()
                    let quoteSnapshot = try decoder.decode(QuoteSnapshot.self, from: json)
                    print(quoteSnapshot)
                    self.stockSnapshots = quoteSnapshot.quoteResponse.result
//                    print("Found these stocks: \(self.stockSnapshots)")

//                    completion(.success(quoteSnapshot.quoteResponse.result))
                }
                catch {
                    print(error)
//                    completion(.failure(error.localizedDescription))
                }
            }
            catch {
                print(error)
//                completion(.failure(error.localizedDescription))
            }
        }
        task.resume()
        
        
        
//        let urlString = Constants.quoteurlString + searchSymbols.uppercased()
//        guard let url = URL(string: urlString) else { return }
//        var request = URLRequest(url: url)
//        request.allHTTPHeaderFields = ["x-api-key": Constants.apiKey]
//        request.httpMethod = "GET"
//
//
//
//
//        // Download Data using Combine. The teacher thinks it is the future of iOS Programming. Very powerful. A lot of the code for this has been refractored and put into static functions in NetworkingManager
//        stockSubscription = NetworkingManager.download(urlRequest: request, url: url)
//            .decode(type: [StockSnapshot].self, decoder: JSONDecoder())
//            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedStocks) in
//                self?.stockSnapshots = returnedStocks
//                self?.stockSubscription?.cancel()
//            })
    }
    
    
    
    
    private struct Constants{
        static let apiKey = "u0oXimhO5g6AIR9DIy85D80DPTAtPQP95l9FiAkk" // started working on 3/12/22
        static let quoteurlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols="
//         'https://yfapi.net/v8/finance/chart/AAPL?range=1d&region=US&interval=5m&lang=en&events=div%2Csplit'
        
//        "https://yfapi.net/v8/finance/chart/AAPL?range=1mo&region=US&interval=1d&lang=en&events=div%2Csplit"
        static let charturlStringStart = "https://yfapi.net/v8/finance/chart/"
        
        static let charturlRange = "?range="
        static let charturlStringInterval = "&region=US&interval="
        static let charturlStringEnd = "&lang=en&events=div%2Csplit"
    }

}





