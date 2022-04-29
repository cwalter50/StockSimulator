//
//  AddWatchlistView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/4/22.
//

import SwiftUI

struct AddWatchlistView: View {
    @State var name: String
    
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
            Button(action: {
                
                // add the WatchList
                let newWatchlist = Watchlist(context: moc)
                newWatchlist.id = UUID()
                newWatchlist.name = name
                newWatchlist.created = Date()

                if moc.hasChanges {
                    try? moc.save()
                }
                presentationMode.wrappedValue.dismiss()
                
            }){
                Text("Save")
            }
            .disabled(name.isEmpty)

        }
    }
}

struct AddWatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        AddWatchlistView(name: "")
    }
}
