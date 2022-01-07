//
//  DeeepMemoApp.swift
//  Shared
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

@main
struct DeeepMemoApp: App {

//    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
//            NavigationView {
//                FolderView(folder: deeperFolder)
//////                    .environmentObject(colorScheme)
//            }
//            testView()
//            HomeView()
//            EmptyView()
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(NavigationStateManager())
                .onAppear {
//                    if persistenceController.container.viewConte
                }
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


