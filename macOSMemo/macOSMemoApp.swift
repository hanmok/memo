//
//  macOSMemoApp.swift
//  macOSMemo
//
//  Created by Mac mini on 2022/01/05.
//

import SwiftUI

@main
struct macOSMemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
