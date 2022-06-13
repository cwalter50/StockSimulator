//
//  AddAccountView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/16/22.
//

import SwiftUI
import Combine

struct AddAccountView: View {
    
    @State var name: String
    
    @State var startingAmount: String
    
    @Environment(\.managedObjectContext) var moc // CoreData

    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section{
                HStack {
                    Text("Name:")
                    TextField("Enter Account Name", text: $name)
                        .autocapitalization(.words)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            Section{
                HStack {
                    Text("Amount:")
                    TextField("Enter Cash Starting Amount", text: $startingAmount)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .onReceive(Just(startingAmount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.startingAmount = "$\(filtered)"
                            }
                        }
                // add more items later like margin account, etc.
                
            }
            Button(action: {
//                saveAccountsToUserDefaults()
                // add the Account
                let cash = Double(self.startingAmount) ?? 1000.00
                let newAccount = Account(context: moc)
                newAccount.id = UUID()
                newAccount.name = name
                newAccount.startingValue = cash
                newAccount.cash = cash
                newAccount.created = Date()
                if moc.hasChanges {
                    try? moc.save()
                }
                presentationMode.wrappedValue.dismiss()
                
            }){
                Text("Save")
            }
            .disabled(name.isEmpty || startingAmount.isEmpty)

        }
        }
    }

}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView(name: "", startingAmount: "")
    }
}
