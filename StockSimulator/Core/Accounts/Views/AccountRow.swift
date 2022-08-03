//
//  AccountRow.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import SwiftUI

struct AccountRow: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    var vm: AccountViewModel
    var account: Account
    
    init(account: Account)
    {
        self.account = account
        vm = AccountViewModel(account: self.account)
    }
    
    var body: some View {
        HStack (alignment: .firstTextBaseline){
            Text(account.wrappedName)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            VStack(alignment: .trailing){
                Text(String(format: "$%.2f", account.currentValue))
                    .font(.headline)
                Text(account.percentChange)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear(perform: updateAccountValue)
        .background {
            Color.theme.background
                .opacity(0.001)
        }
    }
    
    func updateAccountValue()
    {
        
        vm.updateAssetValues()
        var stockSymbols = [String]()
        if let theTransactionsSet = self.account.transactions, let theTransactions = Array(theTransactionsSet) as? [Transaction] {
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
                                t.stock?.updateValuesFromStockSnapshot(snapshot: snapshot)
                            }
                        }
                        try? moc.save()
                        

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
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(account: Account())
    }
}
