//
//  DataController.swift
//  StockSimulator
//
//  Created by Christopher Walter on 3/2/22.
//

import CoreData
import SwiftUI


class DataController: ObservableObject
{
    let container = NSPersistentContainer(name: "StockSimulator")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

