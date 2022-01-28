//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

struct FolderWithLevel: Hashable {
    var folder: Folder
    var level: Int
    var isCollapsed: Bool = false
    var isShowing: Bool = true
    var id = UUID()
}
extension FolderWithLevel : Identifiable {
    
}

struct LevelAndCollapsed {
    var level: Int
    var collapsed: Bool
}


struct MindMapView: View {
    
    let imageSize: CGFloat = 28
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var memoEditViewModel = MemoEditViewModel()
    @StateObject var folderEditViewModel = FolderEditViewModel()
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    var body: some View {
        
        return VStack(spacing: 0) {
        
            Text("Folders")
                .padding(.leading, Sizes.overallPadding)
                .padding(.bottom, 10)
            
            List(fastFolderWithLevelGroup.allFolders) { folderWithLevel in
                if folderWithLevel != fastFolderWithLevelGroup.allFolders.last {
                    FastVerCollapsibleFolder(folder: folderWithLevel.folder, level: folderWithLevel.level)
                        .environmentObject(memoEditViewModel)
                        .environmentObject(folderEditViewModel)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(action: {
                                
                                print("hi")
                            }) {
                                Text("hello")
                            }
                        }
                }
            } // end of List
        
        }
        .navigationBarHidden(true)
    }
}

// text.bubble
// bubble.right.fill
// square.split.1x2.fill
// text.badge.plus
