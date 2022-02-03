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

//return MindMapView(
//    fastFolderWithLevelGroup:
//        FastFolderWithLevelGroup(
//            targetFolder: topFolders.first!))









struct LevelAndCollapsed {
    var level: Int
    var collapsed: Bool
}


struct MindMapView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var memoEditViewModel = MemoEditViewModel()
    @StateObject var folderEditViewModel = FolderEditViewModel()
//    @StateObject var folderOrder = FolderMemoOrder(identity: .folder)
    @StateObject var folderOrder = FolderOrder()
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @FocusState var changingNameFocus: Bool
    
    @State var changedFolderName = ""
    
    @State var showSelectingFolderView = false
    
    var body: some View {
        
        return ZStack {
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
                    Text("Folders")
                        .padding(.leading, Sizes.overallPadding)
                        .padding(.vertical)
                    Spacer()
                    
                    HStack {
                        
                        // sort
                        Menu {
                            
                            Text("Folder Ordering")
                                .font(.title3)
                            
                            FolderOrderingButton(type: .modificationDate, folderOrder: folderOrder)
                            FolderOrderingButton( type: .creationDate, folderOrder: folderOrder)
                            FolderOrderingButton(type: .alphabetical, folderOrder: folderOrder)
                            
                            Divider()
                            
                            FolderAscDecButtonLabel(isAscending: true, folderOrder: folderOrder)
                            FolderAscDecButtonLabel(isAscending: false, folderOrder: folderOrder)
                            
                        } label: {
                            ChangeableImage(imageSystemName: "arrow.up.arrow.down")
                        }
                        .padding(.trailing, Sizes.smallSpacing)
                        
                        // Add new Folder
                        Button {
                            showSelectingFolderView = true
                        } label: {
                            ChangeableImage(imageSystemName: "plus")
                        }
                    }
                    .padding(.trailing, Sizes.overallPadding)
                    .padding(.vertical)
                }
                
                // MARK: - List of all Folders (hierarchy)
                // another VStack
                List(fastFolderWithLevelGroup.allFolders) { folderWithLevel in
                    if folderWithLevel != fastFolderWithLevelGroup.allFolders.last {
                        
                        FastVerCollapsibleFolder(folder: folderWithLevel.folder, level: folderWithLevel.level)
                            .environmentObject(memoEditViewModel)
                            .environmentObject(folderEditViewModel)
                        // without this action, trailing buttons not show up properly..
                        
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                } label: {

                                }
                            }
                    }
                } // end of List
                .onReceive(fastFolderWithLevelGroup.$allFolders) { output in
                    print("fastFolder output: \(output)")
                }
            } // end of VStack
            
            // change Folder Name
            
            PrettyTextFieldAlert(
                placeHolderText: folderEditViewModel.selectedFolder != nil ? "\(folderEditViewModel.selectedFolder!.title)" : "Enter New FolderName",
                type: .rename,
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
                            self.changingNameFocus = true
                        }
                    }
                }
            
            
            
            // name for before and after !
            // and.. some varialbes are not named properly.
            
        } // end of ZStack
        
        
        .sheet(isPresented: $showSelectingFolderView,
               content: {
            SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup)
                .environmentObject(folderEditViewModel)
                .environmentObject(memoEditViewModel)
        })
        .sheet(isPresented: $folderEditViewModel.shouldShowSelectingView, content: {
            SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup)
                .environmentObject(folderEditViewModel)
                .environmentObject(memoEditViewModel)
        })
        .navigationBarHidden(true)
        
        
    }
}

// text.bubble
// bubble.right.fill
// square.split.1x2.fill
// text.badge.plus
