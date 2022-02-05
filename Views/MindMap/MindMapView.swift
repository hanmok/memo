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
//    var id = UUID()
}

//struct FolderWithLevel: Identifiable {
//
//}

struct LevelAndCollapsed {
    var level: Int
    var collapsed: Bool
}


struct MindMapView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var memoEditVM = MemoEditViewModel()
    @StateObject var folderEditVM = FolderEditViewModel()
    @StateObject var folderOrder = FolderOrder()
    @StateObject var memoOrder = MemoOrder()
    
    @State var newFolderName = ""

    @State var showTextField = false
    @State var textFieldType: TextFieldAlertType? = nil
    
    @State var folderToAddSubFolder : Folder? = nil
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @FocusState var textFieldFocus: Bool
    
    @State var showSelectingFolderView = false
    
    var body: some View {
        
        return ZStack {
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
                    Spacer()
                    HStack {
                        // sort
                        FolderOrderingMenu(folderOrder: folderOrder)
                        .padding(.trailing, Sizes.smallSpacing)
                        
                        // Add new Folder to the top Folder
                        Button {
//                            shouldAddFolderToTop = true
                            showTextField = true
                            textFieldType = .newTopFolder
                        } label: {
                            ChangeableImage(imageSystemName: "plus")
                        }
                    }
                    .padding(.trailing, Sizes.overallPadding)
                    .padding(.vertical)
                }
                
                // MARK: - List of all Folders (hierarchy)
                // another VStack
                
                List {
                    Section(header:
                                Text("Folders")
                    ) {
                        ForEach(fastFolderWithLevelGroup.allFolders, id: \.self) {folderWithLevel in
                            
                            FastVerCollapsibleFolder(
                                folder: folderWithLevel.folder,
                                level: folderWithLevel.level)
                                .environmentObject(memoEditVM)
                                .environmentObject(folderEditVM)
                                .environmentObject(memoOrder)
                            // ADD Sub Folder
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        folderToAddSubFolder = folderWithLevel.folder
//                                 shouldAddSubFolder = true
                                        showTextField = true
                                        textFieldType = .newSubFolder
                                    } label: {
                                        ChangeableImage(imageSystemName: "folder.badge.plus")
                                    }
                                    .tint(.blue)
                                }
                            // Change Folder Name
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        showTextField = true
                                        textFieldType = .rename
                                    } label: {
                                        ChangeableImage(imageSystemName: "pencil")
                                    }
                                    .tint(.yellow)
                                }
                        } // end of ForEach
                    } // end of Section
                } // end of List
                .listStyle(InsetGroupedListStyle())
                
            } // end of VStack
            // new Element of ZStack
            
            // MARK: - rename is not currently working .
            PrettyTextFieldAlert(
                type: textFieldType ?? .rename,
                isPresented: $showTextField,
                text: $newFolderName,
                focusState: _textFieldFocus) { newName in
                    
                    switch textFieldType! {
                        
                    case .newTopFolder:
                        let _ = Folder(title: newName, context: context)
                        
                    case .newSubFolder:
                        let newSubFolder = Folder(title: newName, context: context)
                        if let validSubFolder = folderToAddSubFolder {
                            validSubFolder.add(subfolder: newSubFolder)
                        }
                        
                    case .rename:
                        if folderEditVM.selectedFolder != nil {
                            folderEditVM.selectedFolder!.title = newName
                            context.saveCoreData()
                            folderEditVM.selectedFolder = nil
                        }
                    }
                    
                    context.saveCoreData()
                    Folder.updateTopFolders(context: context)
                    
                    newFolderName = ""
                    textFieldType = nil
                    showTextField = false
                } cancelAction: {
                    newFolderName = ""
                    textFieldType = nil
                    showTextField = false
                }
        } // end of ZStack
        
        .sheet(isPresented: $folderEditVM.shouldShowSelectingView, content: {
            SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup)
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        })
        .navigationBarHidden(true)
    }
}

// text.bubble
// bubble.right.fill
// square.split.1x2.fill
// text.badge.plus
