//
//  EditTransactionView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 1/17/23.
//

import SwiftUI

struct EditTransactionView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) var moc
    
    var account: Account
    
    var transaction: Transaction
    
    init(account: Account, transaction: Transaction)
    {
        self.account = account
        self.transaction = transaction
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        let account = dev.sampleAccount
        let transaction = dev.sampleTransaction
        EditTransactionView(account: account, transaction: transaction)
    }
}
