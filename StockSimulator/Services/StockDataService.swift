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
    
//    @Published var chartData: ChartData = ChartData(emptyData: true)
    
    @Published var marketData: [MarketSummary] = []
    

    @Environment(\.managedObjectContext) var moc
    
    var stockSubscription: AnyCancellable?
    init() {
//        getQuoteData(searchSymbols: "")
    }
    
    // I used quickType.io to decode the data. It was having trouble with the ExchangeTimeZone Enum, so I changed that to String and it works great now. More data than I need.
    func getMarketData() {
        
        let apiCaller = APICaller.shared
        apiCaller.getMarketData { connectionResult in
            switch connectionResult {
            case .marketSummarySuccess(let marketData):
                self.marketData = marketData
            case .failure(let string):
                print("Failure: \(string)")
            default:
                print("Found something that was unexpected in getting MarketData")
            }
        }
        
    }
    
    func getQuoteData(searchSymbols: String)
    {
        print("Getting quote data on stock data service")
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
        //                    print(quoteSnapshot)
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
//        let apiCaller = APICaller.shared
//        apiCaller.getQuoteData(searchSymbols: urlString) { connectionResult in
//            switch connectionResult {
//            case .success(let stockSnapshots):
//                self.stockSnapshots = stockSnapshots
//                print("Found \(stockSnapshots.count) stocks")
//            case .failure(let string):
//                print("Failure: \(string)")
//            default:
//                print("Got unexpected result when loading quote data.")
//            }
//        }
        
//        let urlString = Constants.quoteurlString + searchSymbols.uppercased()
//        guard let url = URL(string: urlString) else { return }
//        var request = URLRequest(url: url)
//        request.allHTTPHeaderFields = ["x-api-key": Constants.apiKey]
//        request.httpMethod = "GET"
//
//        // Download Data using Combine. The teacher thinks it is the future of iOS Programming. Very powerful. A lot of the code for this has been refractored and put into static functions in NetworkingManager
//        stockSubscription = NetworkingManager.download(urlRequest: request, url: url)
//            .decode(type: [StockSnapshot].self, decoder: JSONDecoder())
//            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedStocks) in
//                self?.stockSnapshots = returnedStocks
//                self?.stockSubscription?.cancel()
//            })
    }
    
    
//    func updateStockData(searchSymbols: String, stocks: FetchedResults<Stock>)
//    {
//        let urlString = Constants.quoteurlString + searchSymbols.uppercased()
//        let apiCaller = APICaller.shared
//        apiCaller.getQuoteData(searchSymbols: urlString) { connectionResult in
//            switch connectionResult {
//            case .success(let stockSnapshots):
//                self.stockSnapshots = stockSnapshots
//                // update Stock prices in CoreData
//                for snapshot in self.stockSnapshots {
//                    if let stockCoreData = stocks.first(where: {$0.symbol == snapshot.symbol}) {
//                        stockCoreData.updateValuesFromStockSnapshot(snapshot: snapshot)
//
//                        print("updated values for \(stockCoreData.wrappedSymbol)")
//                    }
//
//                }
//                try? self.moc.save()
//            case .failure(let string):
//                print("Failure: \(string)")
//            default:
//                print("Got unexpected result when loading quote data.")
//            }
//        }
//    }
    
    
    
    
    private struct Constants{
        static let apiKey = "u0oXimhO5g6AIR9DIy85D80DPTAtPQP95l9FiAkk" // started working on 3/12/22
        static let quoteurlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols="
//         'https://yfapi.net/v8/finance/chart/AAPL?range=1d&region=US&interval=5m&lang=en&events=div%2Csplit'
        
//        "https://yfapi.net/v8/finance/chart/AAPL?range=1mo&region=US&interval=1d&lang=en&events=div%2Csplit"
        static let charturlStringStart = "https://yfapi.net/v8/finance/chart/"
        
        static let charturlRange = "?range="
        static let charturlStringInterval = "&region=US&interval="
        static let charturlStringEnd = "&lang=en&events=div%2Csplit"
        
        
        static let marketSummaryURL = "https://yfapi.net/v6/finance/quote/marketSummary?lang=en&region=US"
    }

}





