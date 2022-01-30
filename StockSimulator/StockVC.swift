//
//  StockVC.swift
//  APIApp
//
//  Created by Christopher Walter on 4/1/20.
//  Copyright © 2020 DocsApps. All rights reserved.
//
import UIKit

class StockVC: UIViewController {
    /*
    Alpha Vantage API Key
    Welcome to Alpha Vantage! Your dedicated access key is: 8MSMEIW64FB4D1WT. Please record this API key for future access to Alpha Vantage.
    */
    
    @IBOutlet weak var stockButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var stockTF: UITextField!
    
    let apiKey = "8MSMEIW64FB4D1WT"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
    }
    
    @IBAction func stockButtonTapped(_ sender: UIButton) {
        var stockString = stockTF.text!
        
        if stockString == ""
        {
            stockString = "AAPL"
        }
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(stockString)&apikey=\(apiKey)"

         
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
                  return
                }
                print(responseJSON)
                
                let theStock = Stock(data: responseJSON)
//                let dateFormatterGet = DateFormatter()
//                dateFormatterGet.dateFormat = "yyyy-MM-dd"
//                let date = Date()
//                let dateString = dateFormatterGet.string(from: date)
//                print(dateString)
//                let generalData = responseJSON["Meta Data"] as! [String: Any]
//
//                let dayStats = responseJSON["Time Series (Daily)"] as! [String: Any]
//
//                let current = dayStats[dateString] as? [String: String]
//                print(current ?? "error")
//                let close: String = current?["4. close"] ?? "error"
////                print(responseJSON)
                
                 
                DispatchQueue.main.async {
                    self.resultLabel.text = theStock.description
//                    self.resultLabel.text = "\(dateString) Close Price = $\(close)"
                    self.view.endEditing(true)
                }
            }
             
            task.resume()
             
        }
    }
    

}
