//
//  UnitTestHelper.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/01/05.
//

import Foundation
import CoreData

struct UnitTestHelpers {
    
    static func deletesAllMemos(context: NSManagedObjectContext) {
        let request = Memo.fetch(.all)
        
        if let result = try? context.fetch(request) {
            for r in result {
                context.delete(r)
            }
        }
        context.saveCoreData()
    }
    
    static func deletesAllFolders(context: NSManagedObjectContext) {
        let request = Folder.fetch(.all)
        
        if let result = try? context.fetch(request) {
            for r in result {
                context.delete(r)
            }
        }
        context.saveCoreData()
    }
    static func deletesAll2(context: NSManagedObjectContext) {
        UnitTestHelpers.deletesAllFolders(context: context)
        UnitTestHelpers.deletesAllMemos(context: context)
    }
    
    static func deletesAll(container: NSPersistentCloudKitContainer) {
        UnitTestHelpers.deletesAllFolders(context: container.viewContext)
        UnitTestHelpers.deletesAllMemos(context: container.viewContext)
    }
    
    static func deleteBatchRequest(entity: String, container: NSPersistentCloudKitContainer) {
        let context = container.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
}


