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

class FolderGroup: ObservableObject {
    @Published var realFolders: [Folder]
    init(targetFolders: [Folder]) {
        self.realFolders = targetFolders
    }
}

struct LevelAndCollapsed {
    var level: Int
    var collapsed: Bool
}


struct MindMapView: View {
    
    //    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: "Modification Date", memoType: "Creation Date", folderAsc: true, memoAsc: false)
    
    //    @FetchRequest(fetchRequest: Memo.bookMarkedFetchReq()) var memos: FetchedResults<Memo>
    
    //    @FetchRequ
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var memoEditVM = MemoEditViewModel()
    @StateObject var folderEditVM = FolderEditViewModel()
    @StateObject var folderOrder = FolderOrder()
    @StateObject var memoOrder = MemoOrder()
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @FocusState var textFieldFocus: Bool
    
    @State var newFolderName = ""
    @State var showTextField = false
    @State var textFieldType: TextFieldAlertType? = nil
    
    @State var folderToAddSubFolder : Folder? = nil
    @State var showSelectingFolderView = false
    @State var folderToBeRenamed : Folder? = nil
    
    @State var selectionEnum = FolderTypeEnum.folder // default value
    @State var foldersToShow: [Folder] = []
    
    @State var allMemos:[Memo] = []
    
    var body: some View {
        return ZStack {
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
                    Spacer()
                    HStack {
                        // MARK: - Button For Test
                        Button {
                            _ = fastFolderWithLevelGroup.folders.map {
                                print("title: \($0.folder.title)")
                                print("level: \($0.level)")
                            }
//                            for each in fastFolderWithLevelGroup.folders {
//                                print("title: \(each.folder.title)")
//                                print("level: \(each.level)")
//                            }
                        } label: {
                            ChangeableImage(imageSystemName: "magnifyingglass")
                        }

                        // MARK: - Button 1: Folder Ordering
                        FolderOrderingMenu(folderOrder: folderOrder)
                            .padding(.trailing, Sizes.smallSpacing)
                        
                        // MARK: - Button for Test
                        //                        Button {
                        ////                            print(Memo.fetchAllmemos(context: context))
                        //                            allMemos = Memo.fetchAllmemos(context: context)
                        //                            print("num of memos:  \(allMemos.count)")
                        //                            print("num of memos that has no parent: \(allMemos.filter { $0.folder == nil}.count)")
                        //
                        //                        } label: {
                        //                            ChangeableImage(imageSystemName: "folder")
                        //                        }
                        
                        
                        // MARK: - Button 2: Add new Folder to the top Folder
                        Button {
                            showTextField = true
                            textFieldType = .newTopFolder
                        } label: {
                            ChangeableImage(imageSystemName: "folder.badge.plus", width: 28, height: 28)
                            
                                .foregroundColor(colorScheme.adjustBlackAndWhite())
                        }
                    }
                    .padding(.trailing, Sizes.overallPadding)
                    .padding(.vertical)
                }
                
                
                Picker("", selection: $selectionEnum) {
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.folder)).tag(FolderTypeEnum.folder)
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.archive)).tag(FolderTypeEnum.archive)
                }
                .id(selectionEnum)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, Sizes.overallPadding)
                
                // MARK: - List of all Folders (hierarchy)
                // another VStack
                
                
                // MARK: - Start

                ZStack {
                    List {
                        ForEach(fastFolderWithLevelGroup.folders, id: \.self) {folderWithLevel in
                            
                            if folderWithLevel.folder.parent == nil {
                                DynamicTopFolderCell(
                                    folder: folderWithLevel.folder,
                                    level: folderWithLevel.level)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                    .environmentObject(memoOrder)
                                // ADD Sub Folder
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            folderToAddSubFolder = folderWithLevel.folder
                                            showTextField = true
                                            textFieldType = .newSubFolder
                                        } label: {
                                            ChangeableImage(imageSystemName: "folder.badge.plus")
                                        }
                                        .tint(.blue)
                                    }
                            }
                            else {
                                DynamicFolderCell(
                                    folder: folderWithLevel.folder,
                                    level: folderWithLevel.level)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                    .environmentObject(memoOrder)
                                
                                // ADD Sub Folder
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            folderToAddSubFolder = folderWithLevel.folder
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
                                            if folderWithLevel.folder.parent != nil {
                                                showTextField = true
                                                textFieldType = .rename
                                                folderToBeRenamed = folderWithLevel.folder
                                            }
                                        } label: {
                                            ChangeableImage(imageSystemName: "pencil")
                                        }
                                        .tint(.yellow)
                                    }
                            } // end of ForEach
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    // Another ZStack Element
                    List {
                        ForEach(fastFolderWithLevelGroup.archives, id: \.self) {folderWithLevel in
                            if folderWithLevel.folder.parent == nil {
                                DynamicTopFolderCell(
                                    folder: folderWithLevel.folder,
                                    level: folderWithLevel.level)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                    .environmentObject(memoOrder)
                                // ADD Sub Folder
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            folderToAddSubFolder = folderWithLevel.folder
                                            showTextField = true
                                            textFieldType = .newSubFolder
                                        } label: {
                                            ChangeableImage(imageSystemName: "folder.badge.plus")
                                        }
                                        .tint(.blue)
                                    }
                            } else {
                                DynamicFolderCell(
                                    folder: folderWithLevel.folder,
                                    level: folderWithLevel.level)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                    .environmentObject(memoOrder)

                                // ADD Sub Folder
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            folderToAddSubFolder = folderWithLevel.folder
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
                                            if folderWithLevel.folder.parent != nil {
                                                showTextField = true
                                                textFieldType = .rename
                                                folderToBeRenamed = folderWithLevel.folder
                                            }
                                        } label: {
                                            ChangeableImage(imageSystemName: "pencil")
                                        }
                                        .tint(.yellow)
                                    }
                            } // end of ForEach
                        }
                    } // end of List
                    .listStyle(InsetGroupedListStyle())
                    .offset(x: selectionEnum == .folder ? UIScreen.screenWidth : 0)
                } // end of ZStack
                
                // END
                
            } // end of VStack , Inside ZStack.
            BookmarkedFolderView(folder: fastFolderWithLevelGroup.homeFolder)
                .environmentObject(memoEditVM)
                .environmentObject(folderEditVM)
                .environmentObject(memoOrder)
            
            
            // MARK: - rename is not currently working .
            PrettyTextFieldAlert(
                type: textFieldType ?? .rename,
                isPresented: $showTextField,
                text: $newFolderName,
                focusState: _textFieldFocus) { newName in
                    // MARK: - submit Actions
                    switch textFieldType! {
                        
                    case .newTopFolder:
                        let newFolder = Folder(title: newName, context: context)

                        fastFolderWithLevelGroup.folders.first(where: {$0.folder.title == FolderType.getFolderName(type: .folder)})!.folder.add(subfolder: newFolder)

                        
                    case .newSubFolder:
                        let newSubFolder = Folder(title: newName, context: context)
                        if let validSubFolder = folderToAddSubFolder {
                            validSubFolder.add(subfolder: newSubFolder)
                        }
//                        context.saveCoreData()
                        
                    case .rename:
                        if folderToBeRenamed != nil {
                            folderToBeRenamed!.title = newName
                            folderToBeRenamed = nil
                            context.saveCoreData()
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
        
        .fullScreenCover(isPresented: $folderEditVM.shouldShowSelectingView,  content: {
            NavigationView {
                SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup,
                                    invalidFolderWithLevels:
                                        Folder.getHierarchicalFolders(topFolder: folderEditVM.folderToCut),
                                    selectionEnum: selectionEnum,
                                    isFullScreen: true)
                    .environmentObject(folderEditVM)
                    .environmentObject(memoEditVM)
            }
        })
        .navigationBarHidden(true)
    }
}
