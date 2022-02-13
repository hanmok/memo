//
//  SelectingFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/28.
//

import SwiftUI
import CoreData

struct SelectingFolderView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup

    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel

    @Environment(\.colorScheme) var colorScheme
    @State var invalidFolderWithLevels: [FolderWithLevel] = []

    @State var selectionEnum = FolderTypeEnum.folder // default value

    var isFullScreen: Bool = false
  
    var body: some View {
        
        if folderEditVM.folderToCut != nil {
            DispatchQueue.main.async {
                invalidFolderWithLevels = Folder.getHierarchicalFolders(topFolders: [folderEditVM.folderToCut!])
                for each in invalidFolderWithLevels {
                    print("invalidFolder: \(each.folder.title)")
                }
            }
        }
        
        return VStack(spacing: 0) {
            
            HStack {
                Spacer()
                HStack {
                    Text("Select Folder ")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // MARK: - FOR TESTING
                    Button {
                        for each in invalidFolderWithLevels {
                            print("invalidFolder: \(each.folder.title)")
                        }
                    } label: {
                        ChangeableImage(imageSystemName: "star")
                    }
                    
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {

                        ChangeableImage(imageSystemName: "multiply")
                            .foregroundColor(colorScheme.adjustBlackAndWhite())
                        Image(systemName: "").frame(height: 28)
                    }
                }
                .padding(.trailing, Sizes.overallPadding)
                .padding(.vertical)
            }
            
            Picker("", selection: $selectionEnum) {
                
                Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.folder)).tag(FolderTypeEnum.folder)
                
                Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.archive)).tag(FolderTypeEnum.archive)
                
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, Sizes.overallPadding)
            
            if selectionEnum == .folder {
            List(fastFolderWithLevelGroup.folders, id: \.self) { folderWithLevel in
                
                Button {

                    // Select Target Folder to be pasted First.
                    folderEditVM.folderToPaste = folderWithLevel.folder
                    
                    if folderEditVM.folderToCut != nil {
                        
                            invalidFolderWithLevels = Folder.getHierarchicalFolders(topFolders: [folderEditVM.folderToCut!])
                        
                        if Folder.convertLevelIntoFolder(invalidFolderWithLevels).contains(where: { $0 == folderEditVM.folderToPaste}) == true {
                            // INVALIDATE ACTION WHEN PASTED FOLDER IS UNDER CUTTED FOLDER, invalidate action !
                            folderEditVM.folderToCut = nil
                        }
                    }
                    
                    // move only when cutted folder and paste target folder are different.
                    
                    if folderEditVM.folderToCut == folderEditVM.folderToPaste {
                        folderEditVM.folderToCut = nil
                    } else {
                        
                        if folderEditVM.folderToCut != nil {
                            folderEditVM.folderToPaste!.add(subfolder: folderEditVM.folderToCut!)
                            folderEditVM.folderToCut = nil
                            // No Folder to Cut Selected. Memo Cut and Paste!
                        } else {
                            
                            for memo in memoEditVM.selectedMemos.sorted() {
                                folderEditVM.folderToPaste?.add(memo: memo)
                                print("memo to be cut : \(memo.title)")
                            }
                            memoEditVM.initSelectedMemos()
                        }
                        // if Folder to Cut and Paste are the same, do nothing but set both to nil
                    }
                    context.saveCoreData()
                    
                    folderEditVM.folderToPaste = nil
    
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    
                        // MARK: - WHY NOT WORKING ???

                    if invalidFolderWithLevels.contains(where: {$0 == folderWithLevel}) {
                        TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                            .background(.red)
                        
                    } else if folderWithLevel.folder == folderEditVM.folderToCut || folderWithLevel.folder == memoEditVM.parentFolder{
                        // Target and Cutted Folder are the same
                        TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                            .tint(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.8))
                            .background(colorScheme.adjustSubColors())
                        
                    } else {
                        TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                            .background(.blue)
                    }
                }
            } // end of List
            } else {
                List(fastFolderWithLevelGroup.archives, id: \.self) { folderWithLevel in
                    //                if folderWithLevel != fastFolderWithLevelGroup.allFolders.last {
                    
                    Button {
                        print("flag 1")
                        // Select Target Folder to be pasted First.
                        folderEditVM.folderToPaste = folderWithLevel.folder
                        
                        if folderEditVM.folderToCut != nil {
                            
                                invalidFolderWithLevels = Folder.getHierarchicalFolders(topFolders: [folderEditVM.folderToCut!])
                            
                            if Folder.convertLevelIntoFolder(invalidFolderWithLevels).contains(where: { $0 == folderEditVM.folderToPaste}) == true {
                                // INVALIDATE ACTION WHEN PASTED FOLDER IS UNDER CUTTED FOLDER, invalidate action !
                                folderEditVM.folderToCut = nil
                            }
                        }
                        
                        
                        // move only when cutted folder and paste target folder are different.
                        
                        if folderEditVM.folderToCut == folderEditVM.folderToPaste {
                            print("flag 2")
                            folderEditVM.folderToCut = nil
                        } else {
                            
                            if folderEditVM.folderToCut != nil {
                                folderEditVM.folderToPaste!.add(subfolder: folderEditVM.folderToCut!)
                                folderEditVM.folderToCut = nil
                                print("flag 3")
                                // No Folder to Cut Selected. Memo Cut and Paste!
                            } else {
                                print("flag 4")
                                
                                for memo in memoEditVM.selectedMemos.sorted() {
                                    folderEditVM.folderToPaste?.add(memo: memo)
                                    print("memo to be cut : \(memo.title)")
                                }
                                memoEditVM.initSelectedMemos()
                            }
                            // if Folder to Cut and Paste are the same, do nothing but set both to nil
                        }
                        print("flag 5")
                        context.saveCoreData()
                        
                        folderEditVM.folderToPaste = nil
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        if folderWithLevel.folder == folderEditVM.folderToCut || folderWithLevel.folder == memoEditVM.parentFolder{
                            TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                                .tint(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.8))
                                .background(colorScheme.adjustSubColors())
                        } else {
                            TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                        }
                    }
                } // end of List
            }
        }
        .onDisappear {
            UIView.setAnimationsEnabled(true)
        }
        .navigationBarHidden(true)
    }
}
