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
    case marketSummarySuccess([MarketSummary])
    case stockReccomendations([Recommendation])
    case quoteSummarySuccess([QuoteSummary])
//    case success([StockSnapshot])
    case failure(String)
}

final class APICaller{
    static let shared = APICaller()

    private struct Constants{
//        static let apiKey = "JvcnVegPVxaamusnImc1S1pTgWQoSWnB1zwAIrnP" // started working on 3/5/22. Stopped working on 3/12/22
        static let apiKey = "u0oXimhO5g6AIR9DIy85D80DPTAtPQP95l9FiAkk" // started working on 3/12/22
        static let quoteurlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols="

        // https://yfapi.net/v6/finance/recommendationsbysymbol/PYPL
        static let reccomdationsBySymbolURL = "https://yfapi.net/v6/finance/recommendationsbysymbol/"
        static let marketSummaryURL = "https://yfapi.net/v6/finance/quote/marketSummary?lang=en&region=US"
        
        static func quoteSummaryURL(symbol: String) -> String {
        // https://yfapi.net/v11/finance/quoteSummary/ura?lang=en&region=US&modules=defaultKeyStatistics%2CassetProfile
            return "https://yfapi.net/v11/finance/quoteSummary/\(symbol)?lang=en&region=US&modules=defaultKeyStatistics%2CassetProfile%2Cearnings"
        }
        
        static func chartURL(symbol: String, range: String, interval: String) -> String {
//            'https://yfapi.net/v8/finance/chart/AAPL?range=1d&region=US&interval=5m&lang=en&events=div%2Csplit'
            return "https://yfapi.net/v8/finance/chart/\(symbol)?range=\(range)&region=US&interval=\(interval)&lang=en&events=div%2Csplit"
        }
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
//                    print("found QuoteSnapshot")
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
        var interval = "1d"
        
        switch range {
        case "1d":
            interval = "5m"
        case "5d":
            interval = "15m"
        case "1y", "max":
            interval = "1wk"
        default:
            interval = "1d"
        }

        
//    https://yfapi.net/v8/finance/chart/AAPL?range=5d&region=US&interval=15m&lang=en&events=div%2Csplit
        let urlString = Constants.chartURL(symbol: searchSymbol.uppercased(), range: range, interval: interval)
        
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
//                print("loaded chart data for \(searchSymbol). found \(chartData.close.count) pieces of data for close")
                
                completion(.chartSuccess(chartData))
            } catch {
                print("Cannot Decode JSON Response")
                completion(.failure(error.localizedDescription))
                return
            }
        }
        task.resume()
    }
    
    func getChartDataWithSplitsAndDividends(searchSymbol: String, range: String, completion: @escaping (ConnectionResult) -> Void)
    {
//    let urlString = "https://yfapi.net/v8/finance/chart/aapl?range=max&region=US&interval=1mo&lang=en&events=div%2Csplit"
        let urlString = "https://yfapi.net/v8/finance/chart/\(searchSymbol)?range=max&region=US&interval=1mo&lang=en&events=div%2Csplit"
        
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

                completion(.chartSuccess(chartData))
            } catch {
                print("Cannot Decode JSON Response")
                completion(.failure(error.localizedDescription))
                return
            }
        }
        task.resume()
    }
    
    // MARK: Reccomendations by symbol
    /*
     Sample response:
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
    func getReccomendationsBySymbol(symbol: String, completion: @escaping (ConnectionResult) -> Void) {
        // https://yfapi.net/v6/finance/recommendationsbysymbol/PYPL
        let urlString = Constants.reccomdationsBySymbolURL + symbol.uppercased()
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["x-api-key": Constants.apiKey]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            
            // Check for Error Message from API
            guard let results = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

            // check for error message from API Call
            if let message = results["message"] as? String, let hint = results["hint"] as? String {
                print("Message Found: \(message), Hint: \(hint)")
                return
            }
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(StockReccomendations.self, from: data) {
//                print(response)
                completion(.stockReccomendations(response.finance.result))
            }
            else {
                completion(.failure("Failed to get Stock Reccomendations"))
            }
        }
        task.resume()
    }
    
    // MARK: Quote summary contains a description website and other key statistics. BTC-USD does not contain a lot of information so a lot of the model in optional...
    func getQuoteSummary(symbol: String, completion: @escaping (ConnectionResult)-> Void)
    {
        let urlString = Constants.quoteSummaryURL(symbol: symbol)
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["x-api-key": Constants.apiKey]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            
            // Check for Error Message from API
            guard let results = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

//            print(results)
            // check for error message from API Call
            if let message = results["message"] as? String, let hint = results["hint"] as? String {
                print("Message Found: \(message), Hint: \(hint)")
                return
            }
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(Summary.self, from: data) {
                print(response)
                completion(.quoteSummarySuccess(response.quoteSummary.result))
            }
            else {
                completion(.failure("Failed to get Quote Summary"))
            }
        }
        task.resume()
    }
    
    
    // I used quickType.io to decode the data. It was having trouble with the ExchangeTimeZone Enum, so I changed that to String and it works great now.
    func getMarketData(completion: @escaping (ConnectionResult) -> Void) {
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
//                print(response)
                completion(.marketSummarySuccess(response.marketSummaryResponse.result))
//                self.marketData = response.marketSummaryResponse.result
            }
            
        }
        task.resume()
    }
    
    
    
    
    
}


