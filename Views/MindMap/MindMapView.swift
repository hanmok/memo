//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

struct MindMapView: View {
    
    @AppStorage(AppStorageKeys.fOrderAsc) var folderOrderAsc = false
    @AppStorage(AppStorageKeys.fOrderType) var folderOrderType = OrderType.creationDate
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var memoEditVM = MemoEditViewModel()
    @StateObject var folderEditVM = FolderEditViewModel()
    @StateObject var folderOrder = FolderOrder()
    @StateObject var memoOrder = MemoOrder()
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @FocusState var textFieldFocus: Bool
    
    @State var newFolderName = ""
    @State var isShowingTextField = false
    @State var textFieldType: TextFieldAlertType? = nil
    
    @State var folderToAddSubFolder : Folder? = nil
    @State var isShowingSelectingFolderView = false
    @State var folderToBeRenamed : Folder? = nil
    
    @State var selectionEnum = FolderTypeEnum.folder // default value
    @State var foldersToShow: [Folder] = []
    
    @State var isShowingSearchView = false
    @State var isLoading = false
    
//    var hasSafeBottom: Bool {
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        let window = windowScene?.windows.first
//        if (window?.safeAreaInsets.bottom)! > 0 {
//            print("has safeArea!")
//            return true
//        } else {
//            print("does not have safeArea!")
//            return false
//        }
//    }
    
    func deleteFolder() {
        DispatchQueue.main.async {
            isLoading = true
        }
        if let validFolderToRemoved = folderEditVM.folderToRemove {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoading = false
            }
            Folder.moveMemosToTrashAndDelete(from: validFolderToRemoved, to: trashBinVM.trashBinFolder)
            
            folderEditVM.folderToRemove = nil
        }
        context.saveCoreData()
    }
    
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
                            isShowingSearchView = true
                        } label: {
                            SystemImage( "magnifyingglass")
                                .tint(Color.navBtnColor)
                        }
                        
                        // MARK: - Button 2: Folder Ordering
                        FolderOrderingMenu(folderOrder: folderOrder)
                            .padding(.leading, 16)
                        
                        // MARK: - Button 3: Add new Folder to the top Folder
                        Button {
                            isShowingTextField = true
                            if selectionEnum == .folder {
                                textFieldType = .newTopFolder
                                newFolderName = ""
                            } else {
                                textFieldType = .newTopArchive
                                newFolderName = ""
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
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
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
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage("folder.badge.plus")
                                                    .foregroundColor(.black)
                                            }
                                            .tint(Color.swipeBtnColor2)
                                        }
                                    // Change Folder Name
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            
                                            Button {
                                                folderEditVM.folderToRemove = folderWithLevel.folder
                                                isLoading = true
                                                deleteFolder()
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
                                                SystemImage("folder")
                                            }
                                            .tint(Color.swipeBtnColor3)
                                            
                                            Button {
                                                if folderWithLevel.folder.parent != nil {
                                                    isShowingTextField = true
                                                    textFieldType = .rename
                                                    folderToBeRenamed = folderWithLevel.folder
                                                    newFolderName = folderWithLevel.folder.title
                                                }
                                            } label: {
                                                SystemImage("pencil")
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
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
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
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage(  "folder.badge.plus")
                                            }
                                            .tint(Color.swipeBtnColor2)
                                        }
                                    // Change Folder Name
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            // DELETE FOLDER
                                            Button {
                                                folderEditVM.folderToRemove = folderWithLevel.folder
                                                deleteFolder()
                                            } label: {
                                                SystemImage("trash")
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
                                                    isShowingTextField = true
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
                            TrashBinCell()
                                .environmentObject(memoEditVM)
                                .environmentObject(folderEditVM)
                                .environmentObject(memoOrder)
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
            
            if isLoading {
                Color(.clear)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .tint(colorScheme == .dark ? .cream : .black)
            }
            
            BookmarkedFolderView(folder: fastFolderWithLevelGroup.homeFolder
//                                 ,
//                                 hasSafeBottom: hasSafeBottom
            )
                .environmentObject(memoEditVM)
                .environmentObject(folderEditVM)
                .environmentObject(memoOrder)
            
            // animation 은 같지만 이건 ZStack 이기 때문에, 뭔가 차이가 생김.
            // 얘를 fullscreen 으로 만들거나, ..
            
            CustomSearchView(
                fastFolderWithLevelGroup: fastFolderWithLevelGroup, currentFolder: selectionEnum == .folder ? fastFolderWithLevelGroup.homeFolder : fastFolderWithLevelGroup.archive, // 애매하네..
                showingSearchView: $isShowingSearchView,
            shouldShowAll: true,
                shouldIncludeTrashOnCurrent: selectionEnum == .archive,
            shouldIncludeTrashOverall: true)
            
                .offset(y: isShowingSearchView ? 0 : -UIScreen.screenHeight)
                .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.3), value: isShowingSearchView)
                .padding(.horizontal, Sizes.overallPadding)
            
            
            if isShowingTextField {
                Color(.sRGB, white: colorScheme == .dark ? 0.2 : 0.8 , opacity: 0.5)
                    .ignoresSafeArea()
            }
            
            // MARK: - rename is not currently working .
            
            PrettyTextFieldAlert(
                type: textFieldType ?? .rename,
                isPresented: $isShowingTextField,
                text: $newFolderName, //
                focusState: _textFieldFocus) { newName in
                    // MARK: - submit Actions
                    switch textFieldType! {
                        
                    case .newTopFolder:
                        let newFolder = Folder(title: newName, context: context)
                        
                        fastFolderWithLevelGroup.folders.first(
                            where:{FolderType.compareName($0.folder.title, with: .folder)})!.folder.add(subfolder: newFolder)
                        //                            where:{$0.folder.title == FolderType.getFolderName(type: .folder)})!.folder.add(subfolder: newFolder)
                        
                    case .newTopArchive:
                        
                        let newFolder = Folder(title: newName, context: context)
                        
                        fastFolderWithLevelGroup.archives.first(
                            where: {FolderType.compareName($0.folder.title, with: .archive)})!.folder.add(subfolder: newFolder)
                        //                            where: {$0.folder.title == FolderType.getFolderName(type: .archive)})!.folder.add(subfolder: newFolder)
                        
                    case .newSubFolder:
                        let newSubFolder = Folder(title: newName, context: context)
                        if let validSubFolder = folderToAddSubFolder {
                            validSubFolder.add(subfolder: newSubFolder)
                        }
                        
                    case .rename:
                        if folderToBeRenamed != nil {
                            folderToBeRenamed!.title = newName
                            folderToBeRenamed!.modificationDate = Date()
                            folderToBeRenamed = nil
                            
                            context.saveCoreData()
                        }
                    }
                    
                    context.saveCoreData()
                    Folder.updateTopFolders(context: context)
                    
                    newFolderName = ""
                    textFieldType = nil
                    isShowingTextField = false
                } cancelAction: {
                    newFolderName = ""
                    textFieldType = nil
                    isShowingTextField = false
                }
        } // end of ZStack
        
        .fullScreenCover(isPresented: $folderEditVM.shouldShowSelectingView,  content: {
            NavigationView {
                SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup,
                                    selectionEnum: selectionEnum, invalidFolderWithLevels:
                                        Folder.getHierarchicalFolders(topFolder: folderEditVM.folderToCut),
                                    isFullScreen: true)
                    .environmentObject(folderEditVM)
                    .environmentObject(memoEditVM)
            }
        })
        .onAppear(perform: {
            print("MindMapView has Appeared!")
            let allMemosReq = Memo.fetch(.all)
            
            if let allMemos = try? context.fetch(allMemosReq) {
                _ = allMemos.map {
                    if $0.folder == nil {
                        $0.folder = trashBinVM.trashBinFolder
                    }
                }
            }
        })
        .navigationBarHidden(true)
    }
}
