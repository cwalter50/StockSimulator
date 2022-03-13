//
//  AccountView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/26/22.
//

import SwiftUI

struct AccountView: View {
    // CoreData
    @Environment(\.managedObjectContext) var moc
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var account: Account
    
    @FetchRequest var transactions: FetchedResults<Transaction> // transactions need load in init, because FetchRequest requires a predicate with the variable account
    
    
    @State var isSearchPresented = false
    @State var showingDeleteAlert = false
    
    init(account: Account)
    {
        self.account = account
        
        self._transactions = FetchRequest(entity: Transaction.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.buyDate, ascending: true)], predicate: NSPredicate(format: "(ANY account == %@)", self.account), animation: Animation.default)
        
    }
    
    var body: some View {
        VStack(alignment: .center){
            HStack(alignment: .firstTextBaseline){
                Text(account.wrappedName)
                    .font(.title)
                Spacer()
//                Text(String(format: "$%.2f", account.calculateValue()))
//                    .font(.headline)
            }
            Text(String(format: "Cash: $%.2f", account.cash))
                .font(.headline)
            HStack(alignment: .firstTextBaseline) {
                Text("Assests")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isSearchPresented.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $isSearchPresented, onDismiss: {
                    loadCurrentStockInfo()
                }){
                    StockSearchView(theAccount: account)
                }
            }
            List {
                HStack(alignment: .center) {
                    Text("Symbol/Qty")
                    Spacer()
                    Text("Total/Price")
                    Spacer()
                    Text("Total G/L")
                }
                ForEach (account.assets) {
                    asset in
                    AssetRow(asset: asset)
                }
            }
            .listStyle(.plain)
            
            
        }
        .padding(20)
        .navigationTitle("Account Overview")
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete \(account.name ?? "Account")?"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete"), action: deleteAccount), secondaryButton: .cancel())
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
        .onAppear(perform: loadCurrentStockInfo)

//            .navigationBarHidden(true)
        
    }
    
    func loadCurrentStockInfo()
    {
        print("load current Stock Info Called")
        
        
        // load the Stocks
        var stocks = [Stock]()
//        guard let theTransactionsSet = account.transactions else {
//            print("no transactionset")
//            return
//        }
//
//        guard let theTransactions = theTransactionsSet as? [Transaction] else {
//            print("the transactionset is not an array")
//            return
//        }
        for t in transactions {
            if let theStock = t.stock {
                stocks.append(theStock)
            }
        }
        print("found \(stocks.count)")
        
        var searchString = ""
        for s in stocks
        {
            searchString += s.wrappedSymbol+","
        }
        
        let apiCaller = APICaller.shared
        apiCaller.getAllStockData(searchSymbol: searchString) {
            connectionResult in
            
            switch connectionResult {
                case .success(let theStocks):
                    // link the stocks to the current stock prices, update the values,
                    for snapshot in theStocks
                    {
                        if let stockCoreData = stocks.first(where: {$0.symbol == snapshot.symbol}) {
                            stockCoreData.updateValuesFromStockSnapshot(snapshot: snapshot)
                            
                            stockCoreData.regularMarketPrice -= 1
//                            var rand = Int.random(in: 1...100)
//                            stockCoreData.displayName = "Pear\(rand)"
                            print("updated values for \(stockCoreData.wrappedSymbol)")
                        }
                    }
                
                if moc.hasChanges {
                    try? moc.save()
                }
                case .failure(let error):
                    print(error)

            }
        }
        
       
    }
    
    func deleteAccount()
    {
        moc.delete(account)

            // uncomment this line if you want to make the deletion permanent
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: Account())
    }
}
