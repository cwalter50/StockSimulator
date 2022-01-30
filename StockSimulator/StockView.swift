//
//  StockView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/29/22.
//

import SwiftUI

struct StockView: View {
    
    @State var searchSymbol: String = ""
    @State var foundStock: Bool = false
    @State var stock: Stock
    
    var body: some View {
        VStack {
            HStack {
                TextField("StockSymbol", text: $searchSymbol, prompt: Text("Enter Stock Symbol"))
                Button(action: getStockData) {
                    Text("Search")
                }
                
            }
            .padding()
            if foundStock
            {
                Text(stock.symbol)
                
                Text("\(stock.price)")
            }
        }
    }
    
    func getStockData()
    {
        
        let apiKey = "BEDD33LJaE8HYMSFDX1Sf1lMVbkR3CKU518oCr8x"
        let urlString = "https://yfapi.net/v8/finance/chart/AAPL"
         
        if let url = URL(string: urlString)
        {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["x-api-key": apiKey]
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data else { return }
                print(data)
                var responseJSON: [String:Any] = [String:Any]()
                do {
                    guard let results = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                        print("cant unwrap JSON response")
                        return
                    }
                    responseJSON = results
                    print(responseJSON)
                } catch {
                    print("Cannot Decode JSON Respons")
                    return
                }
            }
            task.resume()
        }
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
//                self.stock = Stock(data: responseJSON)
//                foundStock = true
////                let theStock = Stock(data: responseJSON)
//                print(stock.description)
//            }
//
//            task.resume()
//
//        }
    
    }
    
    
    func getStockInfo()
    {
        print(searchSymbol)
        let apiKey = "8MSMEIW64FB4D1WT"
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(searchSymbol)&apikey=\(apiKey)"

         
        if let url = URL(string: urlString)
        {
             
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                var responseJSON: [String: Any] = [String: Any]()
                do {
                  guard let results = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Cannot unwrap JSON response")
                    return
                  }
                  responseJSON = results
                }
                catch {
                  print("Cannot decode JSON response")
                    foundStock = false
                  return
                }
//                print(responseJSON)
                
                self.stock = Stock(data: responseJSON)
                foundStock = true
//                let theStock = Stock(data: responseJSON)
                
                print(stock.description)

                
                 
//                DispatchQueue.main.async {
//                    self.resultLabel.text = theStock.description
////                    self.resultLabel.text = "\(dateString) Close Price = $\(close)"
//                    self.view.endEditing(true)
//                }
            }
             
            task.resume()
             
        }
    }
    
    
}


struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        
        StockView(stock: Stock())
    }
}
