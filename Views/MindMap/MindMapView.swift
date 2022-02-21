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
    
    @AppStorage(AppStorageKeys.fOrderType) var fOrderType = OrderType.modificationDate
    
    
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
    
    @State var showingDeleteAction = false
    @State var allMemos:[Memo] = []
    @State var showingSearchView = false
    
    var body: some View {
        DispatchQueue.main.async {
            print("hi")
        }
        return ZStack {
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
                    Spacer()
                    HStack {
                        
                        Button {
                            print("Folder OrderType: \(fOrderType)")
                        } label: {
                            Text("Test")
                        }

                        // MARK: - Button 1: SEARCH
                        Button {
                            _ = fastFolderWithLevelGroup.folders.map {
                                print("title: \($0.folder.title)")
                                print("level: \($0.level)")
                            }
                            // show SearchView !
                            showingSearchView = true
                        } label: {
                            ChangeableImage(imageSystemName: "magnifyingglass")
                        }

                        // MARK: - Button 2: Folder Ordering
//                        FolderOrderingMenu(folderOrder: folderOrder)
                        FolderOrderingMenu()
                            .padding(.horizontal, Sizes.smallSpacing)
                        
                        
                        // MARK: - Button 3: Add new Folder to the top Folder
                        Button {
                            showTextField = true
//                            textFieldType = .newTopFolder
                            if selectionEnum == .folder {
                                textFieldType = .newTopFolder
                                newFolderName = "\(fastFolderWithLevelGroup.homeFolder.title)'s \(fastFolderWithLevelGroup.homeFolder.subfolders.count + 1) th Folder"
                            } else {
                                textFieldType = .newTopArchive
                                newFolderName = "\(fastFolderWithLevelGroup.archive.title)'s \(fastFolderWithLevelGroup.archive.subfolders.count + 1) th Folder"
                            }

                        } label: { // original : 28
                            ChangeableImage(imageSystemName: "folder.badge.plus", width: 28, height: 28)
//                            ChangeableImage(imageSystemName: "folder.badge.plus")
                                .foregroundColor(colorScheme.adjustBlackAndWhite())
                        }
                    }
                    .padding(.trailing, Sizes.overallPadding)
                    .padding(.top, 8) // original " 12
                }
                .padding(.trailing, Sizes.overallPadding)
                
                
                Picker("", selection: $selectionEnum) {
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.folder))
                        .tag(FolderTypeEnum.folder)
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.archive)).tag(FolderTypeEnum.archive)
                }
                .tint(.pink)
                .id(selectionEnum)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, Sizes.overallPadding)
                
                // MARK: - List of all Folders (hierarchy)
                // another VStack
                
                
                // MARK: - Start

                ZStack {
                    VStack(spacing: 0) {
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
                                            newFolderName = "\(folderWithLevel.folder.title)'s \(folderWithLevel.folder.subfolders.count + 1) th Folder"
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
                                            newFolderName = "\(folderWithLevel.folder.title)'s \(folderWithLevel.folder.subfolders.count + 1) th Folder"
                                        } label: {
                                            ChangeableImage(imageSystemName: "folder.badge.plus")
                                        }
                                        .tint(.blue)
                                    }
                                // Change Folder Name
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        
                                        
                                        Button {
                                            showingDeleteAction = true
                                            folderEditVM.folderToRemove = folderWithLevel.folder
                                        } label: {
                                            ChangeableImage(imageSystemName: "trash")
                                        }
                                        .tint(.red)
                                        
                                        
                                        // RELOCATE FOLDER
                                        Button {
                                            UIView.setAnimationsEnabled(false)
                                            folderEditVM.shouldShowSelectingView = true
                                            folderEditVM.folderToCut = folderWithLevel.folder
                                        } label: {
//                                            ChangeableImage(imageSystemName: "arrowshape.turn.up.right.fill")
                                            ChangeableImage(imageSystemName: "folder")
                                        }
                                        .tint(.green)
                                    
                                        Button {
                                            if folderWithLevel.folder.parent != nil {
                                                showTextField = true
                                                textFieldType = .rename
                                                folderToBeRenamed = folderWithLevel.folder
                                                newFolderName = folderWithLevel.folder.title
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
                        
                    Rectangle()
//                            .foregroundColor(.clear)
//                            .background(.clear)
                            .foregroundColor(colorScheme == .dark ? .black : Color(white: 242 / 255))
                            .background(colorScheme == .dark ? .black : Color(white: 242 / 255))
//                            .frame(height: 150)
                            .frame(height: 185)
                    }
                    
                    // Another ZStack Element
                    VStack {
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
                                            newFolderName = "\(folderWithLevel.folder.title)'s \(folderWithLevel.folder.subfolders.count + 1) th Folder"
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
                                            newFolderName = "\(folderWithLevel.folder.title)'s \(folderWithLevel.folder.subfolders.count + 1) th Folder"
                                        } label: {
                                            ChangeableImage(imageSystemName: "folder.badge.plus")
                                        }
                                        .tint(.blue)
                                    }
                                // Change Folder Name
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        
                                        
                                        // DELETE FOLDER
                                        Button {
                                            showingDeleteAction = true
                                            folderEditVM.folderToRemove = folderWithLevel.folder
                                        } label: {
                                            ChangeableImage(imageSystemName: "trash")
                                        }
                                        .tint(.red)
                                        
                                        
                                        // RELOCATE FOLDER
                                        Button {
                                            UIView.setAnimationsEnabled(false)
                                            folderEditVM.shouldShowSelectingView = true
                                            folderEditVM.folderToCut = folderWithLevel.folder
                                        } label: {
                                            ChangeableImage(imageSystemName: "arrowshape.turn.up.right.fill")
                                        }
                                        .tint(.green)
                                        
                                        Button {
                                            if folderWithLevel.folder.parent != nil {
                                                showTextField = true
                                                textFieldType = .rename
                                                folderToBeRenamed = folderWithLevel.folder
                                                newFolderName = folderWithLevel.folder.title
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
                        EmptyView()
                            .frame(height: 250)
                    }
                    .offset(x: selectionEnum == .folder ? UIScreen.screenWidth : 0)
                } // end of ZStack
                .padding(.horizontal, Sizes.overallPadding)
                
                // END
                
            } // end of VStack , Inside ZStack.
            BookmarkedFolderView(folder: fastFolderWithLevelGroup.homeFolder)
                .environmentObject(memoEditVM)
                .environmentObject(folderEditVM)
                .environmentObject(memoOrder)
            
                
            CustomSearchView(fastFolderWithLevelGroup: fastFolderWithLevelGroup, currentFolder: selectionEnum == .folder ? fastFolderWithLevelGroup.homeFolder : fastFolderWithLevelGroup.archive, showingSearchView: $showingSearchView)
                .offset(y: showingSearchView ? 0 : -UIScreen.screenHeight)
                .animation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0.4), value: showingSearchView)
                .padding(.horizontal, Sizes.overallPadding)
            
            
            // MARK: - rename is not currently working .
            
            PrettyTextFieldAlert(
                type: textFieldType ?? .rename,
                isPresented: $showTextField,
                text: $newFolderName, //
                focusState: _textFieldFocus) { newName in
                    // MARK: - submit Actions
                    switch textFieldType! {
                        
                    case .newTopFolder:
                        let newFolder = Folder(title: newName, context: context)

                        fastFolderWithLevelGroup.folders.first(where: {$0.folder.title == FolderType.getFolderName(type: .folder)})!.folder.add(subfolder: newFolder)

                    case .newTopArchive:
                        
                        let newFolder = Folder(title: newName, context: context)

                        fastFolderWithLevelGroup.archives.first(where: {$0.folder.title == FolderType.getFolderName(type: .archive)})!.folder.add(subfolder: newFolder)
                    
                    case .newSubFolder:
                        let newSubFolder = Folder(title: newName, context: context)
                        if let validSubFolder = folderToAddSubFolder {
                            validSubFolder.add(subfolder: newSubFolder)
                        }
                        
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
        
        .alert(AlertMessages.alertDeleteMain, isPresented: $showingDeleteAction, actions: {
            // delete
            Button(role: .destructive) {
                if let validFolderToRemoved = folderEditVM.folderToRemove {
                    Folder.delete(validFolderToRemoved)
                    folderEditVM.folderToRemove = nil
                }
                context.saveCoreData()
            } label: {
                Text(AlertMessages.deleteConfirm)
            }
            
            Button(role: .cancel) {
                folderEditVM.folderToRemove = nil
            } label: {
                Text(AlertMessages.cancel)
            }
        }, message: {
            Text(AlertMessages.alertDeleteSub).foregroundColor(.red)
        })
    
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

struct AlertMessages {
    static let deleteConfirm = "Delete"
    static let cancel = "Cancel"
    static let alertDeleteMain = "Are you sure to delete?"
    static let alertDeleteSub = "All deleted are NOT Recoverable. "
}
