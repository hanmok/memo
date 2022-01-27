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
        
        return ZStack(alignment: .topLeading) {
                ScrollView(.vertical) {
                    
                    VStack {
                     /*   // For testing
                        TestView()
                        
                        List {
                            ForEach(1 ..< 18) { index in
                                Text("\(index)")
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Text("hi")
                                    }
                            }
                        }
                        */
                        
                        HStack {
                        Text("Folders")
                                .padding(.leading, Sizes.overallPadding + Sizes.smallSpacing)
                        Spacer()
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                
                                ForEach(fastFolderWithLevelGroup.allFolders, id: \.self) { folderwithlevel in
                                    
                                    
                                    HStack {
                                        ForEach(0..<folderwithlevel.level) { _ in
                                            Text("  ")
                                        }
                                        FastVerCollapsibleFolder(folder: folderwithlevel.folder)
                                            .environmentObject(memoEditViewModel)
                                            .environmentObject(folderEditViewModel)
                                        
                                    } // end of HStack
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, Sizes.smallSpacing)
                                    
                                    Rectangle()
                                        .frame(height: 0.5)
                                        .foregroundColor(Color(.sRGB, white: 1, opacity: 1))
                                        .padding(.horizontal, 10)

                                } // end of ForEach, means each Folder cell
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button(action: {print("to the left")}) {
                                        Text("1")
                                    }
                                }
                        }
                        .padding(.vertical, 5)
                        .background(Color(.sRGB, white: 0.95, opacity: 1))
                        .cornerRadius(5)
                        .padding(.horizontal, Sizes.overallPadding)
                    }
                    }
                
                } // end of scrollView
                .navigationBarHidden(true)
        }
    }
}

// text.bubble
// bubble.right.fill
// square.split.1x2.fill
// text.badge.plus
