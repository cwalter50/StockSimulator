////
////  APICaller.swift
////  StockSimulator
////
////  Created by Christopher Walter on 1/29/22.
////
//
//import Foundation
//
//final class APICaller{
//    static let shared = APICaller()
//    
//    private struct Constants{
//        static let apiKey = "C120E6F5-11DD-48D4-8715-E9734B5D56ED"
////        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1asserts/"
//        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1/assets/"
////        http://rest-sandbox.coinapi.io/v1/assets/?apikey=C120E6F5-11DD-48D4-8715-E9734B5D56ED
//    }
//    
//    private init() {}
//    
//    public func getAllCryptoData(
//        completion: @escaping (Result<[Coin], Error>) -> Void){
//        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else {
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else{
//                return
//            }
//            do{
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String: Any]]
////                print(json)
//                var coins = [Coin]()
//                for C in json
//                {
////                    print(C["asset_id"] ?? "no asset_id")
////                    print(C["price_usd"] ?? "no price_usd")
//                    let name = C["asset_id"] as? String
//                    let price = C["price_usd"] as? Double
//                    if let n = name, let p = price
//                    {
//                        let coin = Coin(name: n, price: p)
//                        coins.append(coin)
//                    }
//                    
//                   
//                }
//                completion(.success(coins))
//            }
//            catch{
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}
