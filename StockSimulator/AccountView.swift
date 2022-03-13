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
    
    @State var isSearchPresented = false
    @State var showingDeleteAlert = false
    
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
                    // figure out how to load the asset on this page after the asset is bought or sold.
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

//            .navigationBarHidden(true)
        
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
