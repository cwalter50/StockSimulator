//
//  StockView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/29/22.
//

import SwiftUI

struct StockView: View {
    
    @State var searchSymbol: String = ""
//    @State var foundStock: Bool = false
    @State var stock: Stock?
    
    var body: some View {
        VStack {
            HStack {
                TextField("StockSymbol", text: $searchSymbol, prompt: Text("Enter Stock Symbol"))
                Button(action: getStockData) {
                    Text("Search")
                }
                
            }
            .padding()
            if stock != nil
            {
                Text(stock!.symbol)
                
                Text("$\(stock!.regularMarketPrice)")
            }
        }
    }
    
    func getStockData()
    {
        
        let apiKey = "BEDD33LJaE8HYMSFDX1Sf1lMVbkR3CKU518oCr8x"
//        let urlString = "https://yfapi.net/v8/finance/chart/AAPL"
//        let urlString = "https://yfapi.net/v8/finance/spark?symbols=AAPL,MSFT"
//        let urlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=AAPL%2CBTC-USD%2CEURUSD%3DX"
//        let urlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=AAPL"
        let urlString = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=" + searchSymbol.uppercased()

        if let url = URL(string: urlString)
        {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["x-api-key": apiKey]
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data else { return }
//                print(data)
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
                            let investmentArray = try decoder.decode([Stock].self, from: json)
                            if investmentArray.count > 0
                            {
                                stock = investmentArray[0]
                            }
                            else
                            {
                                stock = nil
                            }
     
                        } catch {
                            print(error)
                        }
                        
//                        print(investmentResults)
                    }
                    
                } catch {
                    print("Cannot Decode JSON Response")
                    return
                }
            }
            task.resume()
        }

    
    }
    
    
//    func getStockInfo()
//    {
//        print(searchSymbol)
//        let apiKey = "8MSMEIW64FB4D1WT"
//        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(searchSymbol)&apikey=\(apiKey)"
//
//         
//        if let url = URL(string: urlString)
//        {
//             
//            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//                guard let data = data else { return }
////                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
//                var responseJSON: [String: Any] = [String: Any]()
//                do {
//                  guard let results = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//                    print("Cannot unwrap JSON response")
//                    return
//                  }
//                  responseJSON = results
//                }
//                catch {
//                  print("Cannot decode JSON response")
//                    foundStock = false
//                  return
//                }
////                print(responseJSON)
//                
//                self.stock = Stock(data: responseJSON)
//                foundStock = true
////                let theStock = Stock(data: responseJSON)
//                
//                print(stock.description)
//
//                
//                 
////                DispatchQueue.main.async {
////                    self.resultLabel.text = theStock.description
//////                    self.resultLabel.text = "\(dateString) Close Price = $\(close)"
////                    self.view.endEditing(true)
////                }
//            }
//             
//            task.resume()
//             
//        }
//    }
    
    
}


struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        
        StockView()
    }
}
