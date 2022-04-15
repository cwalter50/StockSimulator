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
        //        let urlString = "https://yfapi.net/v8/finance/chart/AAPL"
        //        let urlString = "https://yfapi.net/v8/finance/spark?symbols=AAPL,MSFT"
        //        let urlString =
    }

    private init() {}
    
    // this will get stock snapshots for all or multiple stocks... format needs to be SYMBOLA,SYMBOLB,SYMBOLC,... Max of 10 symbols
//    public func getAllStockData(searchSymbol: String, completion: @escaping (Result<Stock, Error>) -> Void){
    public func getQuoteData(searchSymbols: String, completion: @escaping (ConnectionResult) -> Void){
        let urlString = Constants.quoteurlString + searchSymbols.uppercased()
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
//                    print(results)
                // results will sometimes display a message like ["message": Limit Exceeded]
                if let message = results["message"] as? String
                {
                    completion(.failure(message))
                }
                if let quoteResponse = results["quoteResponse"] as? [String:Any], let investmentResults = quoteResponse["result"] as? [[String:Any]] {
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: investmentResults)
                        let decoder = JSONDecoder()
                        let investmentArray = try decoder.decode([StockSnapshot].self, from: json)
//                        print(investmentArray)
                        print("loaded stock data for url \(url.absoluteString)")
                        completion(.success(investmentArray))

                    } catch {
                        print(error)
                        completion(.failure(error.localizedDescription))
                    }
//                        print(investmentResults)
                }
                
            } catch {
                print("Cannot Decode JSON Response")
                completion(.failure(error.localizedDescription))
                return
            }
        }
        task.resume()
    }
    
    func getChartData(searchSymbol: String, range: String, completion: @escaping (ConnectionResult) -> Void)
    {
        var interval = "1d"

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
    
    
}


