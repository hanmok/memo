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
    
    @AppStorage(AppStorageKeys.isFirstLaunch) var isFirstLaunch = true
    @AppStorage(AppStorageKeys.isFirstLaunchAfterBookmarkUpdate) var isFirstAfterBookmarkUpdate = true
    
    let memoEditVM = MemoEditViewModel()
    let folderEditVM = FolderEditViewModel()
    let folderOrder = FolderOrder()
    let memoOrder = MemoOrder()
    let messageVM = MessageViewModel()
    
    private func removeDuplicateFolder(of type: FolderTypeEnum, from folders: [Folder]) {
        
        var topMainFolders = folders.filter { $0.parent == nil && FolderType.compareName($0.title, with: type)}
        
        if topMainFolders.count > 1 {
            print("numOfTopFolders: \(topMainFolders.count), type: \(type)")
            topMainFolders = topMainFolders.sorted { $0.creationDate < $1.creationDate }
            let target = topMainFolders.remove(at: 0)
            
            if type != .trashbin {
                
                for source in topMainFolders {
                    Folder.relocateAll(from: source, to: target)
                    Folder.deleteWithoutUpdate(source)
                }
            } else { // type is trashbin ..
                for dummyTrashFolder in topMainFolders {
                    Folder.deleteWithoutUpdate(dummyTrashFolder)
                }
            }
        }
    }
    
    
    var body: some Scene {
        print("isFirstLaunch: \(isFirstLaunch)")
//        isFirstLaunch = true
        
        // Resolving Duplicate Folder Prob
        let foldersReq = Folder.fetch(.all)
        
        if let folders = try? persistenceController.container.viewContext.fetch(foldersReq) {
            print("all Folders: ")
            folders.forEach { print($0.title) }
            print("all Folders printed !")
            
            for eachType in FolderTypeEnum.allCases {
                removeDuplicateFolder(of: eachType, from: folders)
            }
            persistenceController.container.viewContext.saveCoreData()
        }
        
        if isFirstLaunch {
            print("isFirstLaunch is true !! flaggggggggg !!!!")
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
            
        }
//        else {
//            let folderReq = Folder.fetch(.all)
//            if let folders = try? persistenceController.container.viewContext.fetch(folderReq) {
//                folders.forEach {
//                    print("folder Name: \($0.title)")
//                }
//            }
////            let newFolder = Folder.provideInitialFolder(context: persistenceController.container.viewContext)
////            persistenceController.container.viewContext.saveCoreData()
//            print("no newFolders. it's not first launch! ")
//        }
        
        
        
        
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
