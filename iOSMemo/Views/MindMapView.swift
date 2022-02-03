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
    
    @State var shouldChangeFolderName = false
    @State var shouldAddFolderToTop = false
    @State var shouldAddSubFolder = false
    
    @State var changedFolderName = ""
    @State var newSubFolderName = ""
    @State var newTopFolderName = ""
    
    @State var folderToAddSubFolder : Folder? = nil
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    
    @FocusState var changingNameFocus: Bool
    
    
    @State var showSelectingFolderView = false
    
    var body: some View {
        
        return ZStack {
            VStack(spacing: 0) {
                // MARK: - TOP Views
                HStack {
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
                            
                            FolderAscDecButton(isAscending: true, folderOrder: folderOrder)
                            FolderAscDecButton(isAscending: false, folderOrder: folderOrder)
                            
                        } label: {
                            ChangeableImage(imageSystemName: "arrow.up.arrow.down")
                        }
                        .padding(.trailing, Sizes.smallSpacing)
                        
                        // Add new Folder to the top Folder
                        Button {
                            //                            showSelectingFolderView = true
                            //                            print(fastFolderWithLevelGroup.allFolders)
                            //                            Folder.updateTopFolder(context: context)
                            //                            Folder.up
                            
                            //                            let folder = Folder(title: "home", context: context)
                            
                            //                            Folder.topFolderFetch()
                            //                            context.saveCoreData()
                            //                            Folder.updateTopFolders(context: context)
                            shouldAddFolderToTop = true
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
                        ForEach(fastFolderWithLevelGroup.allFolders) {folderWithLevel in
                            
                            
                            //                            if folderWithLevel != fastFolderWithLevelGroup.allFolders.last {
                            
                            FastVerCollapsibleFolder(folder: folderWithLevel.folder, level: folderWithLevel.level)
                                .environmentObject(memoEditViewModel)
                                .environmentObject(folderEditViewModel)
                            
                            // without this action, trailing buttons not show up properly..
                            //                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            //                                        Button {
                            //                                            let newFolder = Folder(title: "new Folder", context: context)
                            //                                            context.saveCoreData()
                            //                                            let topFolders = Folder.topFolderFetch()
                            //                                            let folders = Folder.fetch(.all)
                            //                                        } label: {
                            //
                            //                                        }
                            //                                    }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        //                                            let counts = folderWithLevel.folder.subfolders.count
                                        //                                            let some = folderWithLevel.folder.subfolders.count
                                        //                                            let newFolder = Folder(title: "under level\(counts + 1)", context: context)
                                        
                                        //                                            folderWithLevel.folder.add(subfolder: newFolder)
                                        //                                            context.saveCoreData()
                                        //                                            folderWithLevel.folder.title += ""
                                        //                                            Folder.updateTopFolders(context: context)
                                        
                                        folderToAddSubFolder = folderWithLevel.folder
                                        shouldAddSubFolder = true
                                    } label: {
                                        Text("under")
                                    }
                                }
                            
                            //                            }
                        } // end of ForEach
                    } // end of Section
                } // end of List
                .listStyle(InsetGroupedListStyle())
                
                .onReceive(fastFolderWithLevelGroup.$allFolders) { output in
                    print("fastFolder output: \(output)")
                }
                
            } // end of VStack
            
            //MARK: - change Folder Name
            
            PrettyTextFieldAlert(
                placeHolderText: folderEditViewModel.selectedFolder != nil ? "\(folderEditViewModel.selectedFolder!.title)" : "Enter New FolderName",
                type: .rename,
                //                isPresented: $folderEditViewModel.shouldChangeFolderName,
                isPresented: $shouldChangeFolderName,
                text: $changedFolderName,
                focusState: _changingNameFocus) { newName in
                    
                    if folderEditViewModel.selectedFolder != nil {
                        folderEditViewModel.selectedFolder!.title = newName
                        context.saveCoreData()
                        folderEditViewModel.selectedFolder = nil
                    }
                    
                    // setup initial name empty
                    changedFolderName = ""
//                    shouldChangeFolderName = false
                } cancelAction: {
                    changedFolderName = ""
//                    shouldChangeFolderName = false
                }
            //                .onReceive(folderEditViewModel.$shouldChangeFolderName) { output in
            //                    //                print("output : \(output)")
            //                    if output == true {
            //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
            //                            self.changingNameFocus = true
            //                        }
            //                    }
            //                }
            
            
            //MARK: - add Folder To Top Level
            
            PrettyTextFieldAlert(
                placeHolderText: "New Top Folder",
                type: .newTopFolder,
                isPresented: $shouldAddFolderToTop,
                text: $newTopFolderName,
                focusState: _changingNameFocus) { newName in
                    let newFolder = Folder(title: newName, context: context)
                    context.saveCoreData()
                    
                    Folder.updateTopFolders(context: context)
                    newTopFolderName = ""
//                    shouldAddFolderToTop = false
                } cancelAction: {
                    newTopFolderName = ""
//                    shouldAddFolderToTop = false
                }
            
            
            // MARK: - Add SubFolder
            PrettyTextFieldAlert(
                placeHolderText: "New SubFolder",
                type: .newSubFolder,
                //                isPresented: $folderEditViewModel.shouldChangeFolderName,
                isPresented: $shouldAddSubFolder,
                text: $newSubFolderName,
                focusState: _changingNameFocus) { newName in
                    
                    let newSubFolder = Folder(title: newName, context: context)
                    if let validSubFolder = folderToAddSubFolder {
                        validSubFolder.add(subfolder: newSubFolder)
                    }
                    
                    Folder.updateTopFolders(context: context)
                    context.saveCoreData()
                    
                    newSubFolderName = ""
//                    shouldAddSubFolder = false
                } cancelAction: {
                    newSubFolderName = ""
//                    shouldAddSubFolder = false
                }
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
