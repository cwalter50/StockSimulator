////
////  APICaller.swift
////  StockSimulator
////
////  Created by Christopher Walter on 1/29/22.
////

import Foundation


enum ConnectionResult {
    case success([StockSnapshot])
    case chartSuccess(ChartData)
//    case success([StockSnapshot])
    case failure(String)
}

final class APICaller{
    static let shared = APICaller()

    private struct Constants{
//        static let apiKey = "BEDD33LJaE8HYMSFDX1Sf1lMVbkR3CKU518oCr8x" // stopped working 2/23/2022
//        static let apiKey = "g4Kz4cnymT3w6iiUfowfT8s0Nthdk35adU4tjEq5" // stopped working on 3/5/22
//        static let apiKey = "JvcnVegPVxaamusnImc1S1pTgWQoSWnB1zwAIrnP" // started working on 3/5/22. Stopped working on 3/12/22
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

    private init() {}
    
    // MARK: this will get stock snapshots for all or multiple stocks... format needs to be SYMBOLA,SYMBOLB,SYMBOLC,... Max of 10 symbols
    public func getQuoteData(searchSymbols: String, completion: @escaping (ConnectionResult) -> Void){
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
                    completion(.failure(message))
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: results)
//                    print(json)
                    let decoder = JSONDecoder()
                    let quoteSnapshot = try decoder.decode(QuoteSnapshot.self, from: json)
//                    print(quoteSnapshot)

                    completion(.success(quoteSnapshot.quoteResponse.result))
                }
                catch {
                    print(error)
                    completion(.failure(error.localizedDescription))
                }
            }
            catch {
                print(error)
                completion(.failure(error.localizedDescription))
            }
        }
        task.resume()
    }
    
    func getChartData(searchSymbol: String, range: String, completion: @escaping (ConnectionResult) -> Void)
    {
        let interval = "1d"

//        if range == "1d" || range == "5d"
//        {
//            interval = "15m"
//        }
//        guard let url = URL(string: Constants.charturlStringPt1 + searchSymbol.uppercased() + Constants.charturlRange + range + Constants.charturlStringPt2 + interval + Constants.charturlStringPt3) else {
//            return
//        }
        
//    https://yfapi.net/v8/finance/chart/AAPL?range=5d&region=US&interval=15m&lang=en&events=div%2Csplit
        let urlString = "https://yfapi.net/v8/finance/chart/\(searchSymbol.uppercased())?range=\(range)&region=US&interval=\(interval)&lang=en&events=div%2Csplit"
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
//                print(results)
                if let message = results["message"] as? String {
                    completion(.failure(message))
                }
//                print(results)
                let chartData = ChartData(results: results)
//                print(chartData)
                print("loaded chart data for \(searchSymbol). found \(chartData.close.count) pieces of data for close")
                
                completion(.chartSuccess(chartData))
            } catch {
                print("Cannot Decode JSON Response")
                completion(.failure(error.localizedDescription))
                return
            }
        }
        task.resume()
    }
    
    
    // I used quickType.io to decode the data. It was having trouble with the ExchangeTimeZone Enum, so I changed that to String and it works great now.
    func getMarketData() {
        let urlString = Constants.marketSummaryURL
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["x-api-key": Constants.apiKey]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            
            guard let results = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

            // check for error message from API Call
            if let message = results["message"] as? String, let hint = results["hint"] as? String {
                print("Message Found: \(message), Hint: \(hint)")
                return
            }

            
            guard let json = try? JSONSerialization.data(withJSONObject: results) else {return}
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(CompleteMarketSummary.self, from: json) {
                print(response)
                let marketData = response.marketSummaryResponse.result
                print(marketData)
            }
            
        }
        task.resume()
    }
    
    
}


