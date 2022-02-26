//
//  AddAccountView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 2/16/22.
//

import SwiftUI

struct AddAccountView: View {
    
    @State var name: String
    
    @State var startingAmount: String
    
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
                }
                // add more items later like margin account, etc.
                
            }
            Button(action: {
                saveAccountsToUserDefaults()
            }){
                Text("Save")
            }

        }
    }
    
    func loadAccountsFromUserDefaults() -> [Account]
    {
        var accounts = [Account]()
        if let theAccounts = UserDefaults.standard.data(forKey: "accounts")
        {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Account].self, from: theAccounts) {
                accounts = decoded
                print("loaded Accounts from userdefaults in AddAccountView")
                print("found \(accounts.count) accounts")
                
            }
        }
        else {
            print("No record of accounts in user defaults on AddAccountView")
        }
        return accounts
    }
    
    func saveAccountsToUserDefaults()
    {
        // load all previous accounts, add this account to the list, save the account to the list, save all accounts to User defaults
        
        var accounts = loadAccountsFromUserDefaults()
        
        // add new account to accounts, and save it.
        let cash = Double(self.startingAmount) ?? 1000.00
        
        let newAccount = Account(name: self.name, cash: cash)
        
        accounts.append(newAccount)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(accounts) {
            UserDefaults.standard.set(encoded, forKey: "accounts")
            print("saving accounts to UserDefaults: \(accounts.count) accounts")
        }
        else {
            print("failed to save anything to user defaults")
        }
        
        // dismiss view
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView(name: "", startingAmount: "")
    }
}
