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
    
    var body: some Scene {
        WindowGroup {
//            NavigationView {
//                FolderView(folder: deeperFolder)
//////                    .environmentObject(colorScheme)
//            }
            MindMapView(homeFolder: deeperFolder)
//            CollapsibleMind(type: .folder, folder: deeperFolder)
//            CollapsibleMind(folder: deeperFolder)
//            CollapsibleView()
//            TestLazyAndScrollView()
//            TestView()
//PopUpButtonView()
        }
    }
}
