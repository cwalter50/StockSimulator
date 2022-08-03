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
//    @EnvironmentObject var vm : StocksViewModel

    // will allow us to dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section{
                HStack {
                    Text("Name:")
                    TextField("Enter Watchlist Name", text: $name)
                        .autocapitalization(.words)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            Button(action: {
//                vm.addWatchlist(name: name)
                // add the WatchList
                let newWatchlist = Watchlist(context: moc)
                newWatchlist.id = UUID()
                newWatchlist.name = name
                newWatchlist.created = Date()

                if moc.hasChanges {
                    try? moc.save()
                }
                print("view should dismiss")
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
            .environment(\.managedObjectContext, dev.dataController.container.viewContext)
//            .environmentObject(dev.stockVM)
    }
}
