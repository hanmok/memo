//
//  DeeepMemoApp.swift
//  Shared
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

@main
struct DeeepMemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FolderView(folder: deeperFolder)
            }
//            TestLazyAndScrollView()
//            TestView()
//PopUpButtonView()
        }
    }
}
