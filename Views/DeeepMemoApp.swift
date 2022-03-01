//
//  DeeepMemoApp.swift
//  Shared
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData

@main
struct DeeepMemoApp: App {

    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    var body: some Scene {
        print("isFirstLaunch: \(isFirstLaunch)")
        
        
////         For testing
//        // for Dev
//        let foldersReq = Folder.fetch(.all)
//
//       if let folders = try? persistenceController.container.viewContext.fetch(foldersReq) {
//           _ = folders.map {
//               print("Folder name to be deleted: \($0.title)")
//               Folder.delete($0)}
//           persistenceController.container.viewContext.saveCoreData()
//       }
//
//        if !isFirstLaunch {
//            let newFolders = Folder.returnSampleFolder3(context: persistenceController.container.viewContext)
//            persistenceController.container.viewContext.saveCoreData()
//            print("newFolders: \(newFolders)")
//            isFirstLaunch = false
//        }
            
            // For Product
            if isFirstLaunch {
                let newFolders = Folder.returnSampleFolder3(context: persistenceController.container.viewContext)
                persistenceController.container.viewContext.saveCoreData()
                print("newFolders: \(newFolders)")
                isFirstLaunch = false
            }
            
        
        
        return WindowGroup {
            HomeView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
        
        
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background :
                print("Scene is in background")
                try? persistenceController.container.viewContext.save()
            case .inactive:
                try? persistenceController.container.viewContext.save()
                print("Scene is in inactive")
            case .active:
                print("Scene is in active")
            @unknown default:
                try? persistenceController.container.viewContext.save()
                print("Scene is in default")
            }
        }
    }
}
