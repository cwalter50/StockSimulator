//
//  AccountsView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/16/22.
//

import SwiftUI

struct AccountsView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    @Environment(\.editMode) private var editMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.created, ascending: false)], animation: Animation.default) var accounts: FetchedResults<Account>
    

    @State var isAddAccountPresented = false
    
    @State var showingDeleteAlert = false
    
    @State var selectedAccount = Account()
    
//    init()
//    {
//        // load accounts from userDefaults
////        accounts = [Account]()
//        loadAccountsFromUserDefaults()
//
//    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) {
                    account in
                    NavigationLink(destination: AccountView(account: account)) {
                        AccountRow(account: account)
                    }

                }
                .onDelete(perform: delete)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddAccountPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isAddAccountPresented, onDismiss: loadAccountsFromUserDefaults) {
                        AddAccountView(name: "", startingAmount: "")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .navigationTitle("Accounts")

        }
        .onAppear(perform: {
            print("onAppearCalled from AccountsView")
            loadAccountsFromUserDefaults()
        })
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
    func delete(at offsets: IndexSet) {
//        accounts.remove(atOffsets: offsets)
//        saveToUserDefaults()
        
        for index in offsets {
            let account = accounts[index]
            moc.delete(account)
        }
        
        try? moc.save()
        
    }
    
    func saveToUserDefaults()
    {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(accounts) {
//            UserDefaults.standard.set(encoded, forKey: "accounts")
//            print("saving accounts to UserDefaults: \(accounts.count) accounts")
//        }
//        else {
//            print("failed to save accounts to user defaults")
//        }
    }
    
    
    func loadAccountsFromUserDefaults ()
    {
//        // load accounts from userDefaults
//        accounts = [Account]()
//        if let theAccounts = UserDefaults.standard.data(forKey: "accounts")
//        {
//            let decoder = JSONDecoder()
//            if let decoded = try? decoder.decode([Account].self, from: theAccounts) {
//                accounts = decoded
//                print("loaded Accounts from userdefaults in accounts view")
//                print("found: \(accounts.count) accounts")
////                return
//            }
//        }
//        else {
//            print("No record of accounts in user defaults")
//        }
    }
    
    
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        AccountsView()
    }
}
