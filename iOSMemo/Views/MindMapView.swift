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
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var memoEditViewModel = MemoEditViewModel()
    @StateObject var folderEditViewModel = FolderEditViewModel()
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @FocusState var changingNameFocus: Bool
    
    @State var changedFolderName = ""
    
    
    
    var body: some View {
        
        return ZStack {
            VStack(spacing: 0) {
                
                
                //
                //            Text("Folders")
                //                .padding(.leading, Sizes.overallPadding)
                //                .padding(.bottom, 10)
                
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
                
            } // end of VStack
            
            TextFieldAlert(
                isPresented: $folderEditViewModel.shouldChangeFolderName,
                text: $changedFolderName,
                focusState: _changingNameFocus) { newName in

                    if folderEditViewModel.selectedFolder != nil {

                    folderEditViewModel.selectedFolder!.title = newName
                        context.saveCoreData()
                        folderEditViewModel.selectedFolder = nil
                    }
                    
                // setup initial name empty
                changedFolderName = ""
            } cancelAction: {
                changedFolderName = ""
            }
            .onReceive(folderEditViewModel.$shouldChangeFolderName) { output in
//                print("output : \(output)")
                if output == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                        print("hi")
                        self.changingNameFocus = true
                    }
                }
            }
            

            
        } // end of ZStack
        .navigationBarHidden(true)
    }
}

// text.bubble
// bubble.right.fill
// square.split.1x2.fill
// text.badge.plus
