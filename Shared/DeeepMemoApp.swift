//
//  DeeepMemoApp.swift
//  Shared
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

@main
struct DeeepMemoApp: App {

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
//    @Environment var nav: NavigationStateManager
    var body: some Scene {
        WindowGroup {
//            NavigationView {
//                FolderView(folder: deeperFolder)
//////                    .environmentObject(colorScheme)
//            }
            testView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
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



//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        print("Finished launching!")
//        return true
//    }
//    func applicationDidFinishLaunching(_ application: UIApplication) {
//        <#code#>
//    }
//
//
//}
