//
//  File.swift
//  assessment
//
//  Created by Amal Alqadhibi on 21/02/2024.
//

import Foundation
import CoreData




struct CoreDataManager {
        static let shared = CoreDataManager()
        
        let container: NSPersistentContainer = NSPersistentContainer(name: "User")
    
    var viewContext: NSManagedObjectContext {
            return container.viewContext
        }
        
        
         init() {
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
            }
        }
    
    func saveContext(){
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }

    
    
    
    
}
