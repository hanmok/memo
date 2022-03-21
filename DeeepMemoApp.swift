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
    
//    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @AppStorage(AppStorageKeys.isFirstLaunch) var isFirstLaunch = true
    @AppStorage(AppStorageKeys.isFirstLaunchAfterBookmarkUpdate) var isFirstAfterBookmarkUpdate = true
    
    let memoEditVM = MemoEditViewModel()
    let folderEditVM = FolderEditViewModel()
    let folderOrder = FolderOrder()
    let memoOrder = MemoOrder()
    let messageVM = MessageViewModel()
    
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
//            let newFolders = Folder.provideInitialFolders(context: persistenceController.container.viewContext)
//            persistenceController.container.viewContext.saveCoreData()
//            print("newFolders: \(newFolders)")
//            isFirstLaunch = false
//        }
            
        //            // For Product
        // how do i.. know..?
        
        // two steps for not providing more folders than 3
        
        if isFirstLaunch {
            let folderReq = Folder.fetch(.all)

            if let folders = try? persistenceController.container.viewContext.fetch(folderReq) {
                if folders.count == 0 {
                    let newFolders = Folder.provideInitialFolders(context: persistenceController.container.viewContext)
                    persistenceController.container.viewContext.saveCoreData()
                    print("newFolders: \(newFolders.count)")
                } else if folders.count < 3 {
                     folders.forEach { Folder.delete($0)}
                    let newFolders = Folder.provideInitialFolders(context: persistenceController.container.viewContext)
                    persistenceController.container.viewContext.saveCoreData()
                    print("newFolders: \(newFolders.count)")
                }
            }

            isFirstLaunch = false
            isFirstAfterBookmarkUpdate = false
        } else {
            print("no newFolders. it's not first launch! ")
        }
        
        
        
        return WindowGroup {
            HomeView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(memoEditVM)
            .environmentObject(folderEditVM)
            .environmentObject(folderOrder)
            .environmentObject(memoOrder)
            .environmentObject(messageVM)
            
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
