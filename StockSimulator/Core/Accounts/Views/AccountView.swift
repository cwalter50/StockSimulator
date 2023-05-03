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
    
    @State var showDetailView = false
    @State var selectedAsset: Asset? = nil
    
    @State var accountName = ""
    @State var notes = ""

    init (account: Account)
    {
        self.account = account

        vm = AccountViewModel(account: account)
        accountName = account.wrappedName
//        _vm = StateObject(wrappedValue: AccountViewModel(account: account))
        

    }
    
    var body: some View {
            VStack(alignment: .center){
                nameAndNotesView
                NavigationLink(destination: TransactionsView(account: account)) {
                    Text("See Transactions")
                }
                //            Button {
                //                testSampleSplit()
                //            } label: {
                //                Text("Test Sample Split")
                //            }
                //
                Button {
                    testSampleDividend()
                } label: {
                    Text("Test Sample Dividend")
                }
                
                NavigationLink(destination: DividendView(account: account)) {
                    Text("See Dividends")
                }
                
                
                accountBalanceAndCashView
                
                
                Divider()
                holdingBarView
                    .alert(isPresented: $showingErrorAlert) {
                        Alert(title: Text("Error"), message: Text("\(errorMessage)"), dismissButton: .default(Text("OK")))
                    }
                holdingListView

//            }
        }
        .background {
            if let sa = selectedAsset {
                NavigationLink(destination: AssetView(asset: sa, account: account), isActive: $showDetailView) {
                    EmptyView()
                }
            } else {
                EmptyView()
            }
            
                
            
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
        accountName = vm.account.wrappedName
        notes = vm.account.wrappedNotes
    }
    
    func deleteAccount()
    {
        print("deleteAccount called")
        moc.delete(account)
        try? moc.save()
    }
    
    func updateAccountName() {
        self.account.name = accountName
        if moc.hasChanges {
            try? moc.save()
        }
        print("Updating Name \(accountName)")
    }
}

struct AccountView_Previews: PreviewProvider {

    static var previews: some View {
        AccountView(account: dev.sampleAccount)
    }
}

extension AccountView {
    
    var nameAndNotesView: some View {
        VStack {
            HStack(alignment: .firstTextBaseline){
                TextField("Account Name", text: $accountName)
                    .font(.title)
                    .onSubmit(updateAccountName)
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
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text("Notes: ")
                    .font(.title3)
                TextEditor(text: $notes)
                    .autocapitalization(.sentences)
                    .foregroundColor(.secondary)
                    .frame(height: 50, alignment: .topLeading)
                    .clipped()
                    .onChange(of: notes) { newValue in
                        account.notes = newValue
                        if moc.hasChanges {
                            try? moc.save()
                        }
                        print("updated notes of account")
                    }
            }
            
        }
    }
    
    
    var accountBalanceAndCashView: some View {
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
    }
    
    var holdingListView: some View {
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
                    AssetRow(asset: asset)
                        .onTapGesture {
                            selectedAsset = asset
                            showDetailView.toggle()
                        }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    var holdingBarView: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Holdings")
                .font(.headline)
            Spacer()
            Button(action: {
                loadCurrentStockInfo()
                HapticManager.notification(type: .success)
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
    }
}
