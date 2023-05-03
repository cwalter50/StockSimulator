//
//  AccountsView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/16/22.
//

import SwiftUI

struct AccountsView: View {
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.created, ascending: false)], animation: Animation.default) var accounts: FetchedResults<Account>
    
//    @ObservedObject var viewModel = AccountsViewModel()

    @State var isAddAccountPresented = false
    
    @State var showDetailView: Bool = false
    @State var selectedAccount: Account? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) {
//                ForEach(viewModel.accounts) {
                    account in
                    AccountRow(account: account)
                        .onTapGesture {
                            selectedAccount = account
                            showDetailView.toggle()
                        }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        loadData()
                        HapticManager.notification(type: .success)
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddAccountPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isAddAccountPresented) {
                        AddAccountView(name: "", startingAmount: "")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .navigationTitle("Accounts")
            .onAppear(perform: loadData)
            .background {
                if let ac = selectedAccount {
                    NavigationLink(destination: AccountView(account: ac), isActive: $showDetailView) {
                        EmptyView()
                    }
                }
                else {
                    EmptyView()
                }
            }
            

        }
        .navigationViewStyle(.stack)
        
    }
    
    func loadData () {
        
        for account in accounts {
            let vm = AccountViewModel(account: account)
            vm.updateAssetValues()
        }

    }
    
    
    
    
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = dev.dataController.container.viewContext
        return AccountsView()
            .environment(\.managedObjectContext, context)
        
//        AccountsView()
//            .environment(\.managedObjectContext, dev.dataController.container.viewContext)
    }
}
