//
//  DepositView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 6/12/22.
//

import SwiftUI
import Combine

struct DepositView: View
{
    var account: Account
    
    @State var depositAmount = ""
    
    @State var alertMessage = ""
    @State var alertTitle = ""
    @State var showAlert = false
    
    @Environment(\.managedObjectContext) var moc // CoreData
    
    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Group {
                Section {
                    Text("Deposit Money")
                        .font(.title)
                        .padding()
                    HStack(alignment: .firstTextBaseline) {
                        Text("Account Value: ")
                        Spacer()
                        Text(String(format: "$%.2f", account.currentValue))
                        
                    }
                    .font(.headline)
                    HStack (alignment: .firstTextBaseline){
                        Text("Available Cash: ")
                        Spacer()
                        Text(String(format: "$%.2f", account.cash))
                    }
                    .font(.headline)
                    Divider()
                }
                Section {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Deposit Amount: ")
                            .font(.headline)
                        TextField("Enter amount to deposit",  text: $depositAmount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .onReceive(Just(depositAmount)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.depositAmount = "\(filtered)"
                                }
                            }
                    }
                }
                Section {
                    Button(action: {
                        depositCash()
                    }) {
                        Text("Deposit")
                            .font(.title)
                            .foregroundColor(Color.blue)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: Alert.Button.default(Text("OK")){
                    // dismiss the page if the alert was a success...
                    if alertTitle == "Success" {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
        .padding()
        
    }
    
    func depositCash()
    {
        if let depositAmountNum = Double(depositAmount) {
            
            if depositAmountNum >= 0
            {
                account.cash += depositAmountNum
                account.startingValue += depositAmountNum
                
                if moc.hasChanges {
                    try? moc.save()
                }
                alertMessage = "Success 😀: $\(depositAmount) is deposited!"
                alertTitle = "Success"
                showAlert = true
            }
            else {
                alertMessage = "Error: Failed to deposit $\(depositAmount)"
                alertTitle = "Error"
                showAlert = true
            }
        }
        
    }
}

struct DepositView_Previews: PreviewProvider {
    static var previews: some View {
        DepositView(account: dev.sampleAccount)
    }
}
