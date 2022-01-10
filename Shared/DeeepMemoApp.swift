//
//  DeeepMemoApp.swift
//  Shared
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

@main
struct DeeepMemoApp: App {

    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
//                HomeView() // new Folder should be provided
//            TestView()
            CoreDataTestView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(NavigationStateManager())
        }
        
        
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background :
                print("Scene is in background")
                try? persistenceController.container.viewContext.save()
            case .inactive:
                print("Scene is in inactive")
            case .active:
                print("Scene is in active")
            @unknown default:
                print("Scene is in default")
            }
        }
    }
}
