//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

struct MindMapView: View {
    var homeFolder: Folder
    @State private var shouldNavigate: Bool = false
    var body: some View {
//        NavigationView {
//            CollapsibleMind(folder: homeFolder, shouldNavigate: $shouldNavigate)
//            NavigationLink(isActive: $shouldNavigate, destination: FolderView(folder: <#T##Folder#>), label: <#T##() -> _#>)
//        }
//        ScrollView {
//        CollapsibleMind(folder: homeFolder, shouldNavigate: $shouldNavigate)
        ScrollView {
            LazyVStack {
                CollapsibleMind(folder: homeFolder)
            }
        } // 됐당...!!!!!
//            .frame(height: 5000)
//        }
        // everyFolder has collapsible view.
        
        
    }
}

struct MindMapView_Previews: PreviewProvider {
    static var previews: some View {
        MindMapView(homeFolder: deeperFolder)
    }
}
