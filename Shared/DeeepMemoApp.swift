//
//  DeeepMemoApp.swift
//  Shared
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

@main
struct DeeepMemoApp: App {
//    init() {
//        <#code#>
//    }
    
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
//    @StateObject var expansion : ExpandingClass
    var body: some Scene {
        WindowGroup {
//            NavigationView {
//                FolderView(folder: deeperFolder)
//////                    .environmentObject(colorScheme)
//            }
//            MindMapView(expansion: expansion, homeFolder: deeperFolder)
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
