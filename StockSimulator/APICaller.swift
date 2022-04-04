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
    case failure(Error)
}

final class APICaller{
    static let shared = APICaller()

    private struct Constants{
//        static let apiKey = "BEDD33LJaE8HYMSFDX1Sf1lMVbkR3CKU518oCr8x" // stopped working 2/23/2022
//        static let apiKey = "g4Kz4cnymT3w6iiUfowfT8s0Nthdk35adU4tjEq5" // stopped working on 3/5/22
//        static let apiKey = "JvcnVegPVxaamusnImc1S1pTgWQoSWnB1zwAIrnP" // started working on 3/5/22. Stopped working on 3/12/22
        static let apiKey = "u0oXimhO5g6AIR9DIy85D80DPTAtPQP95l9FiAkk" // started working on 3/12/22
        
//        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1asserts/"
//        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1/assets/"
//        http://rest-sandbox.coinapi.io/v1/assets/?apikey=C120E6F5-11DD-48D4-8715-E9734B5D56ED
        
        static let quoteurlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols="
        
//         'https://yfapi.net/v8/finance/chart/AAPL?range=1d&region=US&interval=5m&lang=en&events=div%2Csplit'
        
//        "https://yfapi.net/v8/finance/chart/AAPL?range=1mo&region=US&interval=1d&lang=en&events=div%2Csplit"
        static let charturlStringPt1 = "https://yfapi.net/v8/finance/chart/"
        
        static let charturlRange = "?range="
        static let charturlStringPt2 = "&region=US&interval="
        static let charturlStringPt3 = "&lang=en&events=div%2Csplit"
        //        let urlString = "https://yfapi.net/v8/finance/chart/AAPL"
        //        let urlString = "https://yfapi.net/v8/finance/spark?symbols=AAPL,MSFT"
        //        let urlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=AAPL%2CBTC-USD%2CEURUSD%3DX"
        //        let urlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=AAPL"
    }

    private init() {}
    

    // this will get stock snapshots for all or multiple stocks... format needs to be SYMBOLA,SYMBOLB,SYMBOLC,... 
//    public func getAllStockData(searchSymbol: String, completion: @escaping (Result<Stock, Error>) -> Void){
    public func getAllStockData(searchSymbol: String, completion: @escaping (ConnectionResult) -> Void){
        guard let url = URL(string: Constants.quoteurlString + searchSymbol.uppercased()) else {
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
                if let quoteResponse = results["quoteResponse"] as? [String:Any], let investmentResults = quoteResponse["result"] as? [[String:Any]] {
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: investmentResults)
                        let decoder = JSONDecoder()
                        let investmentArray = try decoder.decode([StockSnapshot].self, from: json)
//                        print(investmentArray)
                        print("loaded stock data")
                        completion(.success(investmentArray))

//                        if investmentArray.count > 0
//                        {
//                            let stock = investmentArray[0]
//                            completion(.success(stock))
//                        }

                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
//                        print(investmentResults)
                }
                
            } catch {
                print("Cannot Decode JSON Response")
                completion(.failure(error))
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
//            interval = "5m"
//        }
//        guard let url = URL(string: Constants.charturlStringPt1 + searchSymbol.uppercased() + Constants.charturlRange + range + Constants.charturlStringPt2 + interval + Constants.charturlStringPt3) else {
//            return
//        }
        guard let url = URL(string: "https://yfapi.net/v8/finance/chart/\(searchSymbol.uppercased())?range=\(range)&region=US&interval=\(interval)&lang=en&events=div%2Csplit") else {
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
                
//                print(results)
                let chartData = ChartData(results: results)
//                print(chartData)
                print("loaded chart data for \(searchSymbol). found \(chartData.close.count) pieces of data for close")
                
                completion(.chartSuccess(chartData))
            } catch {
                print("Cannot Decode JSON Response")
                completion(.failure(error))
                return
            }
        }
        task.resume()
    }
    
    
}


