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
    
    var account: Account
    
    @ObservedObject var vm: AccountViewModel
    
    @FetchRequest var transactions: FetchedResults<Transaction>
    
    @FetchRequest var holdings: FetchedResults<Holding>
    
    init (account: Account)
    {
        self.account = account
        
        vm = AccountViewModel(account: account)
        _transactions = FetchRequest<Transaction>(sortDescriptors: [], predicate: NSPredicate(format: "account == %@", account))
        
        _holdings = FetchRequest<Holding>(sortDescriptors: [], predicate: NSPredicate(format: "account == %@", account))
        print("init on AccountView Called")
//        loadCurrentStockInfo()
        
    }
    
    
    @State var isSearchPresented = false
    @State var showingDeleteAlert = false
    
    // this should display an error on the api caller
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    
    var body: some View {
        VStack(alignment: .center){
            HStack(alignment: .firstTextBaseline){
                Text(account.wrappedName)
                    .font(.title)
                Spacer()
//                Text(String(format: "$%.2f", account.calculateValue()))
//                    .font(.headline)
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(title: Text("Delete \(account.name ?? "Account")?"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete"), action: deleteAccount), secondaryButton: .cancel())
            }
            Text(String(format: "Cash: $%.2f", account.cash))
                .font(.headline)
            HStack(alignment: .firstTextBaseline) {
                Text("Assests")
                    .font(.headline)
                Spacer()
                Button(action: {
                    loadCurrentStockInfo()
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
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
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Error"), message: Text("\(errorMessage)"), dismissButton: .default(Text("OK")))
            }
            List {
                HStack(alignment: .center) {
                    Text("Symbol/Qty")
                    Spacer()
                    Text("Total/Price")
                    Spacer()
                    Text("Total G/L")
                }
                ForEach (vm.assets) {
                    asset in
                    if asset.totalShares > 0 {
                        VStack{
                            Text(String(format: "$%.2f", asset.stock.regularMarketPrice))
                            NavigationLink(destination: AssetView(asset: asset, account: account)) {
                                AssetRow(asset: asset)
                            }
                        }
                        
                    }
                }
//                ForEach (holdings) {
//                    holding in
//                    HoldingRow(holding: holding)
////                    Text("\(holding.wrappedSymbol)")
//                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(20)
//        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("Account Overview")
        .navigationViewStyle(StackNavigationViewStyle())


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
        
        vm.updateAssetValues()

    }
    
    func deleteAccount()
    {
        print("deleteAccount called")
        moc.delete(account)

            // uncomment this line if you want to make the deletion permanent
        try? moc.save()
//        presentationMode.wrappedValue.dismiss()
    }
}

struct AccountView_Previews: PreviewProvider {

    static var previews: some View {
        
        AccountView(account: dev.sampleAccount())

    }
}
