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
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var memoEditVM = MemoEditViewModel()
    @StateObject var folderEditVM = FolderEditViewModel()
    @StateObject var folderOrder = FolderOrder()
    @StateObject var memoOrder = MemoOrder()
//    @StateObject var
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
//    @ObservedObject var trashBinFolder: Folder
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
    
    var hasSafeBottom: Bool {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        if (window?.safeAreaInsets.bottom)! > 0 {
            print("has safeArea!")
            return true
        } else {
            print("does not have safeArea!")
            return false
        }
        
        
//        if #available(iOS 13.0, *),
//           UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 {
//
////           (UIApplication.UIWindowScene.window?.safeAreaInsets.bottom)! > 0 {
//            print(" it has safeBottom !")
//            return true
//        } else {
//            print("It does not have safeBottom !")
//            return false
//        }
    }
    
    @AppStorage(AppStorageKeys.fOrderAsc) var folderOrderAsc = false
    
    @AppStorage(AppStorageKeys.fOrderType) var folderOrderType = OrderType.creationDate
    
    var body: some View {
        
        
        
        
        return ZStack {
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
                    Spacer()
                    HStack(spacing: 0) {
                        // MARK: - Button 1: SEARCH
                        Button {
                            _ = fastFolderWithLevelGroup.folders.map {
                                print("title: \($0.folder.title)")
                                print("level: \($0.level)")
                            }
                            // show SearchView !
                            showingSearchView = true
                        } label: {

                            SystemImage( "magnifyingglass")
                                .tint(Color.navBtnColor)
                        }

                        // MARK: - Button 2: Folder Ordering
                        FolderOrderingMenu(folderOrder: folderOrder)
                            .padding(.leading, 16)
                        
                        // MARK: - Button 3: Add new Folder to the top Folder
                        Button {
                            showTextField = true
                            if selectionEnum == .folder {
                                textFieldType = .newTopFolder
                                newFolderName = "\(fastFolderWithLevelGroup.homeFolder.title)\(LocalizedStringStorage.possessive) \(fastFolderWithLevelGroup.homeFolder.subfolders.count + 1)\(LocalizedStringStorage.nth) \(LocalizedStringStorage.folder)"
                            } else {
                                textFieldType = .newTopArchive
                                newFolderName = "\(fastFolderWithLevelGroup.archive.title)\(LocalizedStringStorage.possessive) \(fastFolderWithLevelGroup.archive.subfolders.count + 1)\(LocalizedStringStorage.nth) \(LocalizedStringStorage.folder)"
                            }

                        } label: { // original : 28

                            SystemImage( "folder.badge.plus", size: 28)
                                .foregroundColor(Color.navBtnColor)
                        }
                        .padding(.leading, 12)
                    }
                    .padding(.horizontal, 20)

                    .padding(.top, 8)

                }
                .padding(.trailing, Sizes.overallPadding)
                
                
                Picker("", selection: $selectionEnum) {
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.folder))
                        .tag(FolderTypeEnum.folder)
                    Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.archive)).tag(FolderTypeEnum.archive)
                }
                .id(selectionEnum)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, Sizes.overallPadding)
                .padding(.horizontal, Sizes.overallPadding)
                
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
                                    .environmentObject(trashBinVM)
                                // ADD Sub Folder
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            folderToAddSubFolder = folderWithLevel.folder
                                            showTextField = true
                                            textFieldType = .newSubFolder
                                            newFolderName = "\(folderWithLevel.folder.title)\(LocalizedStringStorage.possessive) \(folderWithLevel.folder.subfolders.count + 1)\(LocalizedStringStorage.nth) \(LocalizedStringStorage.folder)"
                                        } label: {

                                            SystemImage("folder.badge.plus")
                                        }

                                        .tint(Color.swipeBtnColor2)
                                    }
                            }
                            else {
                                DynamicFolderCell(
                                    folder: folderWithLevel.folder,
                                    level: folderWithLevel.level)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                    .environmentObject(memoOrder)
                                    .environmentObject(trashBinVM)
                                
                                // ADD Sub Folder
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            folderToAddSubFolder = folderWithLevel.folder
                                            showTextField = true
                                            textFieldType = .newSubFolder
                                            newFolderName = "\(folderWithLevel.folder.title)\(LocalizedStringStorage.possessive) \(folderWithLevel.folder.subfolders.count + 1)\(LocalizedStringStorage.nth) \(LocalizedStringStorage.folder)"
                                        } label: {
                                            SystemImage("folder.badge.plus")
                                                .foregroundColor(.black)
                                            
                                        }
                                        .tint(Color.swipeBtnColor2)
                                    }
                                // Change Folder Name
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        
                                        
                                        Button {
                                            showingDeleteAction = true
                                            folderEditVM.folderToRemove = folderWithLevel.folder
                                        } label: {
                                            SystemImage( "trash")
                                        }
                                        .tint(.red)
                                        
                                        
                                        // RELOCATE FOLDER
                                        Button {
                                            UIView.setAnimationsEnabled(false)
                                            folderEditVM.shouldShowSelectingView = true
                                            folderEditVM.folderToCut = folderWithLevel.folder
                                        } label: {
                                            SystemImage(  "folder")
                                        }
                                        .tint(Color.swipeBtnColor3)
                                    
                                        Button {
                                            if folderWithLevel.folder.parent != nil {
                                                showTextField = true
                                                textFieldType = .rename
                                                folderToBeRenamed = folderWithLevel.folder
                                                newFolderName = folderWithLevel.folder.title
                                            }
                                        } label: {
                                            SystemImage(  "pencil")
                                        }
                                        .tint(Color.swipeBtnColor2)
                                    
                                    }
                            } // end of ForEach
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
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
                                            newFolderName = "\(folderWithLevel.folder.title)\(LocalizedStringStorage.possessive) \(folderWithLevel.folder.subfolders.count + 1)\(LocalizedStringStorage.nth) \(LocalizedStringStorage.folder)"
                                        } label: {
                                            SystemImage(  "folder.badge.plus")
                                        }
                                        .tint(Color.swipeBtnColor2)
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
                                            newFolderName = "\(folderWithLevel.folder.title)\(LocalizedStringStorage.possessive) \(folderWithLevel.folder.subfolders.count + 1) \(LocalizedStringStorage.nth) \(LocalizedStringStorage.folder)"
                                        } label: {
                                            SystemImage(  "folder.badge.plus")
                                        }
                                        .tint(Color.swipeBtnColor2)
                                    }
                                // Change Folder Name
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        
                                        
                                        // DELETE FOLDER
                                        Button {
                                            showingDeleteAction = true
                                            folderEditVM.folderToRemove = folderWithLevel.folder
                                        } label: {
                                            SystemImage(  "trash")
                                        }
                                        .tint(.red)
                                        
                                        
                                        // RELOCATE FOLDER
                                        Button {
                                            UIView.setAnimationsEnabled(false)
                                            folderEditVM.shouldShowSelectingView = true
                                            folderEditVM.folderToCut = folderWithLevel.folder
                                        } label: {
                                            SystemImage(  "folder")
                                        }
                                        .tint(Color.swipeBtnColor3)
                                        
                                        Button {
                                            if folderWithLevel.folder.parent != nil {
                                                showTextField = true
                                                textFieldType = .rename
                                                folderToBeRenamed = folderWithLevel.folder
                                                newFolderName = folderWithLevel.folder.title
                                            }
                                        } label: {
                                            SystemImage("pencil")
                                        }
                                        .tint(Color.swipeBtnColor2)
                                    }
                            } // end of Else Case
                        } // end of ForEach
//                        TrashBinCell(folder: trashBinFolder)
                        TrashBinCell()
                            .environmentObject(memoEditVM)
                            .environmentObject(folderEditVM)
                            .environmentObject(memoOrder)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                
                                Button {
                                    // DO NOTHING
                                } label: {
                                    ChangeableImage(imageSystemName: "multiply")
                                }
                                .tint(.gray)
                            }
                    }// end of List
                    .listStyle(InsetGroupedListStyle())
                       
                        EmptyView()
                            .frame(height: 250)
                    }
                    .offset(x: selectionEnum == .folder ? UIScreen.screenWidth : 0)
                } // end of ZStack
                .padding(.horizontal, Sizes.overallPadding)
                
                // END
                
            } // end of VStack , Inside ZStack.
            BookmarkedFolderView(folder: fastFolderWithLevelGroup.homeFolder, hasSafeBottom: hasSafeBottom)
                .environmentObject(memoEditVM)
                .environmentObject(folderEditVM)
                .environmentObject(memoOrder)
            
            // animation 은 같지만 이건 ZStack 이기 때문에, 뭔가 차이가 생김.
            // 얘를 fullscreen 으로 만들거나, ..
            CustomSearchView(
                fastFolderWithLevelGroup: fastFolderWithLevelGroup, currentFolder: selectionEnum == .folder ? fastFolderWithLevelGroup.homeFolder : fastFolderWithLevelGroup.archive, showingSearchView: $showingSearchView)
            
                .offset(y: showingSearchView ? 0 : -UIScreen.screenHeight)
                .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.3), value: showingSearchView)
                .padding(.horizontal, Sizes.overallPadding)
            
            
            if showTextField {
                Color(.sRGB, white: colorScheme == .dark ? 0.2 : 0.8 , opacity: 0.5)
                    .ignoresSafeArea()
            }
            
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
                            folderToBeRenamed!.modificationDate = Date()
                            folderToBeRenamed = nil // sorry.. ^^_^

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
        
        .alert(LocalizedStringStorage.removeAlertMsgMain, isPresented: $showingDeleteAction, actions: {
            // delete
            Button(role: .destructive) {
                if let validFolderToRemoved = folderEditVM.folderToRemove {
//                    Folder.delete(validFolderToRemoved)
                    Folder.moveMemosToTrashAndDelete(from: validFolderToRemoved, to: trashBinVM.trashBinFolder)
//                    Folder.delete(validFolderToRemoved)
                    folderEditVM.folderToRemove = nil
                }
                context.saveCoreData()
            } label: {
                Text(LocalizedStringStorage.delete)
            }
            
            Button(role: .cancel) {
                folderEditVM.folderToRemove = nil
            } label: {
                Text(LocalizedStringStorage.cancel)
            }
        }, message: {
            Text(LocalizedStringStorage.removeAlertMsgSub).foregroundColor(.red)
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

//struct AlertMessages {
//    static let deleteConfirm = "Delete"
//    static let cancel = "Cancel"
//    static let alertDeleteMain = "Are you sure to delete?"
//    static let alertDeleteSub = "All deleted are NOT Recoverable. "
//}
