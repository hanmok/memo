//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI
/// folderList
struct SecondTabView: View {
    
    @AppStorage(AppStorageKeys.isFirstLaunch) var isFirstLaunch = true
    @AppStorage(AppStorageKeys.isFirstLaunchAfterBookmarkUpdate) var isFirstAfterBookmarkUpdate = true
    @AppStorage(AppStorageKeys.isFirstScreenSecondView) var isFirstScreenSecondView = false
    
    @Environment(\.scenePhase) var scenePhase
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @EnvironmentObject var messageVM: MessageViewModel
    
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
    //    @State var isShowingSecondView = false
    
    //    @State var isShowingSecondView: Bool
    
    @State var isAddingMemo = false
    
    @State var red = 0.0
    @State var green = 0.0
    @State var blue = 0.0
    
    //    @State var msgToShow: String?
    
    init(fastFolderWithLevelGroup: FastFolderWithLevelGroup
         //         ,isShowingSecondView: Bool
    ) {
        self.fastFolderWithLevelGroup = fastFolderWithLevelGroup
        //        _isShowingSecondView = State(initialValue: isShowingSecondView)
    }
    
    func addMemo() {
        isAddingMemo = true
    }
    
    func deleteFolder() {
        DispatchQueue.main.async {
            isLoading = true
        }
        if let validFolderToRemoved = folderEditVM.folderToRemove {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoading = false
                //                msgToShow = Messages.showFolderDeleted(targetFolder: validFolderToRemoved)
                messageVM.message = Messages.showFolderDeleted(targetFolder: validFolderToRemoved)
            }
            Folder.moveMemosToTrashAndDelete(from: validFolderToRemoved, to: trashBinVM.trashBinFolder)
            
            folderEditVM.folderToRemove = nil
        }
        context.saveCoreData()
    }
    
    var body: some View {
        
        return ZStack {
            //        NavigationView {
            //        ZStack {
            
            Color(colorScheme == .dark ? .newBGForDark : .white)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
                    
                    Spacer()
                    HStack(spacing: 0) {
                        
                        // MARK: - Button 1: Folder Ordering
                        FolderOrderingMenu()
//                            .padding(.top, 4)
//                            .padding(.leading, 16)
                            
                        // MARK: - Button 2: Add new Folder to the top Folder
                        Button {
                            isShowingTextField = true
                            //                            if selectionEnum == .folder {
                            textFieldType = .newTopFolder
                            //                                newFolderName = ""
                            //                            } else {
                            //                                textFieldType = .newTopArchive
                            //                                newFolderName = ""
                            //                            }
                            
                        } label: { // original : 28
//                            SystemImage( "folder.badge.plus", size: 28)
                            SystemImage(.Icon.folderPlus, size: 26)
                                .foregroundColor(colorScheme == .dark ? .navColorForDark : .navColorForLight)
                        }
                        .padding(.leading, 14)
//                        .padding(.leading, 12)
                    }
                    .padding(.top, 2)
                    .padding(.horizontal, 20)
                    //                    .padding(.top, 5)
                }
//                .padding(.bottom, 9)
//                .padding(.bottom)
                .padding(.bottom, 14)
//                .padding(.top, 3)
                
                // MARK: - List of all Folders (hierarchy)
                // another VStack
                
                
                // MARK: - Start
                    VStack(spacing: 0) {
                        List { // Main Folder
//                            Section(header: Text("")) {
                                ForEach(fastFolderWithLevelGroup.folders, id: \.self) {folderWithLevel in
                                    
                                    if folderWithLevel.folder.parent == nil {
                                        DynamicTopFolderCell(
                                            folder: folderWithLevel.folder,
                                            level: folderWithLevel.level)
                                        .environmentObject(folderEditVM)
                                        .environmentObject(trashBinVM)
                                        // ADD Sub Folder
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage(.Icon.folderPlus)
                                                    .foregroundColor(.black)
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                        }
                                    }
                                    else {
                                        DynamicFolderCell(
                                            folder: folderWithLevel.folder,
                                            level: folderWithLevel.level)
                                        .environmentObject(folderEditVM)
                                        .environmentObject(trashBinVM)
                                        //                                        .listRowBackground(Color.blue)
                                        // ADD Sub Folder
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage(.Icon.folderPlus)
                                                    .foregroundColor(.black)
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                        }
                                        // Change Folder Name
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            
                                            Button {
                                                folderEditVM.folderToRemove = folderWithLevel.folder
                                                isLoading = true
                                                deleteFolder()
                                            } label: {
                                                SystemImage(.Icon.trash)
                                            }
                                            .tint(.red)
                                            
                                            
                                            // RELOCATE FOLDER
                                            Button {
                                                UIView.setAnimationsEnabled(false)
                                                folderEditVM.shouldShowSelectingView = true
                                                folderEditVM.folderToCut = folderWithLevel.folder
                                            } label: {

                                                SystemImage(.Icon.relocateFill)
                                            }
                                            .tint(Color.lightSwipeBtn2)
                                            
                                            Button {
                                                if folderWithLevel.folder.parent != nil {
                                                    isShowingTextField = true
                                                    textFieldType = .rename
                                                    folderToBeRenamed = folderWithLevel.folder
                                                    newFolderName = folderWithLevel.folder.title
                                                }
                                            } label: {
                                                SystemImage(.Icon.pencil)
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                            
                                        }
                                    } // end of ForEach
                                } // end of ForEach
//                            }
                            
                            Section(header: Text("")) {
                                ForEach(fastFolderWithLevelGroup.archives, id: \.self) {folderWithLevel in
                                    
                                    if folderWithLevel.folder.parent == nil {
                                        DynamicTopFolderCell(
                                            folder: folderWithLevel.folder,
                                            level: folderWithLevel.level)
                                        .environmentObject(folderEditVM)
                                        .environmentObject(trashBinVM)
                                        // ADD Sub Folder
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage(.Icon.folderPlus)
                                                    .foregroundColor(.black)
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                        }
                                    } else {
                                        DynamicFolderCell(
                                            folder: folderWithLevel.folder,
                                            level: folderWithLevel.level)
                                        .environmentObject(folderEditVM)
                                        .environmentObject(trashBinVM)
                                        // ADD Sub Folder
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                folderToAddSubFolder = folderWithLevel.folder
                                                isShowingTextField = true
                                                textFieldType = .newSubFolder
                                                newFolderName = ""
                                            } label: {
                                                SystemImage(.Icon.folderPlus)
                                                
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                            
                                        }
                                        // Change Folder Name
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            // DELETE FOLDER
                                            Button {
                                                folderEditVM.folderToRemove = folderWithLevel.folder
                                                deleteFolder()
                                            } label: {
                                                SystemImage(.Icon.trash)
                                            }
                                            .tint(.red)
                                            
                                            
                                            // RELOCATE FOLDER
                                            Button {
                                                UIView.setAnimationsEnabled(false)
                                                folderEditVM.shouldShowSelectingView = true
                                                folderEditVM.folderToCut = folderWithLevel.folder
                                            } label: {
                                                SystemImage(.Icon.relocateFill)
                                            }
                                            .tint(Color.lightSwipeBtn2)
                                            
                                            Button {
                                                if folderWithLevel.folder.parent != nil {
                                                    isShowingTextField = true
                                                    textFieldType = .rename
                                                    folderToBeRenamed = folderWithLevel.folder
                                                    newFolderName = folderWithLevel.folder.title
                                                }
                                            } label: {
                                                SystemImage(.Icon.pencil)
                                            }
                                            .tint(colorScheme == .dark ? Color.darkSwipeBtn1 : Color.lightSwipeBtn1)
                                        }
                                    } // end of Else Case
                                } // end of ForEach
                            } // end of Section
                                Section(header: Text("")) {
                                    TrashBinCell()
                                        .environmentObject(trashBinVM)

                                } // end of section
                                
//                            }// end of foreach
//                            EmptyView()
                            Rectangle()
                                .frame(height: 32)
                                .foregroundColor(.clear)
                                .background(.clear)
                                .listRowBackground(Color.clear)
                        } // end of List
                    } // end of  vstack
//                  .listStyle(InsetGroupedListStyle())
                    
            } // end of Outer VStack , Inside ZStack.
            
            
            // Anther Element of ZStack
            VStack {
                Spacer()
                HStack {
                    //                    BindedColorView(red: $red, green: $green, blue: $blue)
                    Spacer()
                    Button(action: addMemo) {
//                        NewPlusImage()
                        PlusImage()
                    }
                    .padding([ .trailing], Sizes.overallPadding)
                    .padding(.bottom, 15)
                }
            }
            .background(.clear)
            
            
            NavigationLink(destination:
                            NewMemoView(parent: fastFolderWithLevelGroup.homeFolder, presentingNewMemo: .constant(false)),
                           isActive: $isAddingMemo) {}
            
            if isLoading {
                Color(.clear)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                //                    .tint(colorScheme == .dark ? .cream : .black)
            }
            
            
            CustomSearchView(
                fastFolderWithLevelGroup: fastFolderWithLevelGroup, currentFolder: selectionEnum == .folder ? fastFolderWithLevelGroup.homeFolder : fastFolderWithLevelGroup.archive, // 애매하네..
                showingSearchView: $isShowingSearchView,
                shouldShowAll: true,
                shouldIncludeTrashOnCurrent: selectionEnum == .archive,
                shouldIncludeTrashOverall: true)
            
            .environmentObject(folderEditVM)
            .offset(y: isShowingSearchView ? 0 : -UIScreen.screenHeight)
            .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.3), value: isShowingSearchView)
            //                .padding(.horizontal, Sizes.overallPadding)
            
            
            
            //            SecondMainView(fastFolderWithLevelGroup: fastFolderWithLevelGroup,
            //                       currentFolder: fastFolderWithLevelGroup.homeFolder,
            //                       isShowingSecondView: $isShowingSecondView)
            
            .environmentObject(trashBinVM)
            .offset(x: -UIScreen.screenWidth)
            
            
            if isShowingTextField {
                Color(.sRGB, white: colorScheme == .dark ? 0.25 : 0.8, opacity: 0.9)
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
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
        }
        //        .navigationBarHidden(true)
        //        .navigationBarTitle(Text(""))
        //        } // end of NavigationView
        .fullScreenCover(isPresented: $folderEditVM.shouldShowSelectingView,  content: {
            NavigationView {
                SelectingFolderView(fastFolderWithLevelGroup: fastFolderWithLevelGroup,
                                    invalidFolderWithLevels:
                                        Folder.getHierarchicalFolders(topFolder: folderEditVM.folderToCut),
                                    isFullScreen: true)
                .environmentObject(folderEditVM)
            }
        })
        .alert(LocalizedStringStorage.bookmarkRemovingUpdateAlert, isPresented:
                Binding<Bool>(get: {return !isFirstLaunch && isFirstAfterBookmarkUpdate},
                              set: { _ in } ),
               actions: {
            
            Button(role: .none) {
                
                // Make All bookmarked pinned
                let allMemos = Memo.fetchAllmemos(context: context)
                allMemos.filter { $0.isBookMarked }.forEach{ $0.isPinned = true}
                
                
                DispatchQueue.main.async {
                    isLoading = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isLoading = false
                    messageVM.message = LocalizedStringStorage.completed
                }
                
                isFirstAfterBookmarkUpdate = false
                
            } label: {
                Text(LocalizedStringStorage.done)
            }
            
            Button(role: .cancel ) {
                isFirstAfterBookmarkUpdate = false
            } label: {
                Text(LocalizedStringStorage.cancel)
            }
        })
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .background {
                //                print("isFirstScreenSecondView has updated to \(isShowingSecondView)")
                //                isFirstScreenSecondView = isShowingSecondView
            }
        }
        .navigationBarHidden(true)
    }
}
