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
//    @StateObject var vm: AccountViewModel
    
//    @FetchRequest var transactions: FetchedResults<Transaction>

    @State var isSearchPresented = false
    @State var showingDeleteAlert = false
    
    // this should display an error on the api caller
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    @State var showingDepositView = false

    init (account: Account)
    {
        self.account = account

        vm = AccountViewModel(account: account)
//        _vm = StateObject(wrappedValue: AccountViewModel(account: account))
        

    }
    
    var body: some View {
        VStack(alignment: .center){
            
            NavigationLink(destination: TransactionsView(account: account)) {
                Text("See Transactions")
            }
            Button {
                testSampleSplit()
            } label: {
                Text("Test Sample Split")
            }
            
            Button {
                testSampleDividend()
            } label: {
                Text("Test Sample Dividend")
            }

            HStack(alignment: .firstTextBaseline){
                Text(account.wrappedName)
                    .font(.title)
                Spacer()
                Button(action: {
                    showingDepositView.toggle()
                }) {
                    Text("Deposit $")
                }
//                Text(String(format: "$%.2f", account.calculateValue()))
//                    .font(.headline)
            }
            .sheet(isPresented: $showingDepositView, onDismiss: {
                loadCurrentStockInfo()
            }){
                DepositView(account: account)
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(title: Text("Delete \(account.name ?? "Account")?"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete"), action: deleteAccount), secondaryButton: .cancel())
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(String(format: "Account Value: $%.2f", account.currentValue))
                        .font(.headline)
                    Spacer()
                    
                }
                Text(String(format: "Cash: $%.2f", account.cash))
                    .font(.headline)
                    
            }
            .padding([.top, .bottom])
            Divider()
            HStack(alignment: .firstTextBaseline) {
                Text("Holdings")
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
                        NavigationLink(destination: AssetView(asset: asset, account: account)) {
                            AssetRow(asset: asset)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(10)
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
    
    
    func testSampleSplit()
    {
        vm.testSampleSplit(context: moc)
    }
    
    func testSampleDividend()
    {
        vm.testSampleDividend(context: moc)

    }
    func loadCurrentStockInfo()
    {
        vm.updateAssetValues()
        vm.updateSplitsAndDividends(context: moc)
    }
    
    func deleteAccount()
    {
        print("deleteAccount called")
        moc.delete(account)
        try? moc.save()
    }
}

struct AccountView_Previews: PreviewProvider {

    static var previews: some View {
        AccountView(account: dev.sampleAccount)
    }
}
