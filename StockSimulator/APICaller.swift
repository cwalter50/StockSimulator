////
////  APICaller.swift
////  StockSimulator
////
////  Created by Christopher Walter on 1/29/22.
////

import Foundation


enum ConnectionResult {
   case success(Stock)
   case failure(Error)
}

final class APICaller{
    static let shared = APICaller()

    private struct Constants{
//        static let apiKey = "BEDD33LJaE8HYMSFDX1Sf1lMVbkR3CKU518oCr8x" // stopped working 2/23/2022
        static let apiKey = "g4Kz4cnymT3w6iiUfowfT8s0Nthdk35adU4tjEq5"
        
//        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1asserts/"
//        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1/assets/"
//        http://rest-sandbox.coinapi.io/v1/assets/?apikey=C120E6F5-11DD-48D4-8715-E9734B5D56ED
        
        static let urlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols="
        
        //        let urlString = "https://yfapi.net/v8/finance/chart/AAPL"
        //        let urlString = "https://yfapi.net/v8/finance/spark?symbols=AAPL,MSFT"
        //        let urlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=AAPL%2CBTC-USD%2CEURUSD%3DX"
        //        let urlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=AAPL"
    }

    private init() {}
    

//    public func getAllStockData(searchSymbol: String, completion: @escaping (Result<Stock, Error>) -> Void){
    public func getAllStockData(searchSymbol: String, completion: @escaping (ConnectionResult) -> Void){
        guard let url = URL(string: Constants.urlString + searchSymbol.uppercased()) else {
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
                    print(results)
                if let quoteResponse = results["quoteResponse"] as? [String:Any], let investmentResults = quoteResponse["result"] as? [[String:Any]] {
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: investmentResults)
                        let decoder = JSONDecoder()
                        let investmentArray = try decoder.decode([Stock].self, from: json)
                        print(investmentArray)
                        if investmentArray.count > 0
                        {
                            let stock = investmentArray[0]
                            completion(.success(stock))
                        }

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
}


