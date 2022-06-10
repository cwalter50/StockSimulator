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
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) {
//                ForEach(viewModel.accounts) {
                    account in
                    NavigationLink(destination: AccountView(account: account)) {
                        AccountRow(account: account)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        loadData()
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

        }
        .navigationViewStyle(StackNavigationViewStyle())
        
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
