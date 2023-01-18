//
//  TransactionsView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 7/19/22.
//

import SwiftUI

struct TransactionsView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest var transactions: FetchedResults<Transaction> // transaction need load in init, because FetchRequest requires a predicate with the variable account
    
    var account: Account
    
    init(account: Account) {
        self.account = account
        
        self._transactions = FetchRequest(entity: Transaction.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.buyDate, ascending: false)], predicate: NSPredicate(format: "(ANY account == %@)", self.account), animation: Animation.default)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(transactions) { t in
                    TransactionRow(transaction: t)
                }
                .onDelete(perform: delete)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
    
        for i in offsets {
            let transaction = transactions[i]
            account.removeFromTransactions(transaction)
            moc.delete(transaction)
        }
        if moc.hasChanges {
            try? moc.save()
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        let account = dev.sampleAccount
        TransactionsView(account: account)
    }
}
