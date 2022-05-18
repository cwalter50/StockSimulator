import Foundation
import SwiftUI
import CoreData

enum AccountsDataResult {
    case success([Account])
    case failure(String)
}

final class AccountsViewModel: ObservableObject {
    
    @Environment(\.managedObjectContext) var moc
    
    
//    @Published var myAccounts: [Account]
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.created, ascending: false)], animation: Animation.default) var accounts: FetchedResults<Account>
    
    
    
    public init ()
    {
//        myAccounts = Array(accounts) as? [Account] ?? [Account]()
    }
    
    func loadAccountsValue(completion: @escaping(AccountsDataResult) -> Void) {
        print("loading account values")
        for account in accounts {
            var stockSymbols = [String]()
            if let theTransactionsSet = account.transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction] {
                for t in theTransactions {
                    if let theStock = t.stock {
                        if !stockSymbols.contains(theStock.wrappedSymbol) {
                            stockSymbols.append(theStock.wrappedSymbol)
                        }
                    }
                }
            
                var searchString = ""
                for s in stockSymbols
                {
                    searchString += s+","
                }
                
                let apiCaller = APICaller.shared
                apiCaller.getQuoteData(searchSymbols: searchString) {
                    connectionResult in
                    
                    switch connectionResult {
                        case .success(let theStocks):
                            // link the stocks to the current stock prices, update the values,
                            for snapshot in theStocks
                            {
                                let matchingTransactions = theTransactions.filter({ t in
                                    return t.stock?.wrappedSymbol == snapshot.symbol
                                })
                                for t in matchingTransactions {
                                    t.stock?.updateValuesFromStockSnapshot(snapshot: snapshot) // update the stock price in each transaction, which should then update the account value.
                                    print("updating \(t.stock?.wrappedSymbol ?? "error") for \(t.numShares)")
                                }
                            }
                        try? self.moc.save()
                            

                        case .failure(let error):
                            print(error)
    //                        errorMessage = error
    //                        showingErrorAlert = true
                        
                        default:
                            print("ConnectionResult is not success or failure")

                    }
                }
            }
        }
        print("finished updating all stock prices")
        completion(.success(Array(accounts) as? [Account] ?? [Account]()))
            
        
    }
    
}
