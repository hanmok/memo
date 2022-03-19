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
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup

    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel

    @State var selectionEnum = FolderTypeEnum.folder // default value

//    @State var isValidAction = false
    
    var invalidFolderWithLevels: [FolderWithLevel]
//    var dismissAction: () -> Void = { }
    var isFullScreen: Bool = false
    
    @Binding var msgToShow: String?
    
    var shouldUpdateTopFolder = true
    
    var body: some View {
        
        return VStack(spacing: 0) {
            HStack {
                Spacer()
                HStack {
                    Text(LocalizedStringStorage.selectFolder)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .overlay {
                        HStack {
                            // MARK: - FOR TESTING
                            Spacer()
                            // CANCEL
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                folderEditVM.folderToCut = nil
                                memoEditVM.initSelectedMemos() // ?? should it be ?  yes.
                            } label: {
                                SystemImage( "multiply")
                                    .foregroundColor(Color.blackAndWhite)
                                Text("").frame(height: 28)
                            }
                        }
                        .padding(.trailing, Sizes.overallPadding)
                        .padding(.vertical)
                    }
                }
            }
            .frame(height: 28)
            .padding(.top, 7)
            
            Picker("", selection: $selectionEnum) {
                Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.folder)).tag(FolderTypeEnum.folder)
                Image(systemName: FolderType.getfolderImageName(type: FolderTypeEnum.archive)).tag(FolderTypeEnum.archive)
            }
            .id(selectionEnum)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, Sizes.overallPadding + 1)
            
            if selectionEnum == .folder {
                List(fastFolderWithLevelGroup.folders, id: \.self)  { folderWithLevel in
                    Button {
                        folderEditVM.folderToPaste = folderWithLevel.folder
                        // 폴더 옮기는 과정.
                        if folderEditVM.folderToCut != nil {
                            // 본인 아래의 Hierarchy 로 옮기는 경우 무효처리
                            if Folder.convertLevelIntoFolder(invalidFolderWithLevels).contains(folderEditVM.folderToPaste!) {
                                folderEditVM.folderToCut = nil
                            } else {
                                folderEditVM.folderToPaste?.add(subfolder: folderEditVM.folderToCut!)
                                msgToShow = Messages.showFolderMovedMsg(targetFolder: folderEditVM.folderToCut!, to: folderEditVM.folderToPaste!)
                                folderEditVM.folderToCut!.modificationDate = Date()
//                                isValidAction = true
                            }
                            // 메모 이동.
                        } else {
                            memoEditVM.selectedMemos.forEach { folderEditVM.folderToPaste!.add(memo: $0)
                                $0.modificationDate = Date()
                                msgToShow = Messages.showMemoMovedMsg(memoEditVM.count, to: folderEditVM.folderToPaste!)
                            }
                            
//                            isValidAction = true
                            
                            memoEditVM.initSelectedMemos()
                        }
                        
                        folderEditVM.folderToPaste = nil
                        
                        context.saveCoreData()
                        
//                        folderEditVM.folderToPaste = nil
//                        if isValidAction {
//                            dismissAction()
//                        }

                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        
                        if invalidFolderWithLevels.contains(folderWithLevel) {
                            CheckableFolderCell(folder: folderWithLevel.folder, level: folderWithLevel.level, markInvalid: true)
                            
//                        } else if folderWithLevel.folder == folderEditVM.folderToCut || folderWithLevel.folder == memoEditVM.parentFolder{
                        } else if folderWithLevel.folder == folderEditVM.folderToCut || memoEditVM.folderRelated.contains(folderWithLevel.folder){
                            CheckableFolderCell(folder: folderWithLevel.folder, level: folderWithLevel.level, markCheck: true)
                        } else {
                            CheckableFolderCell(folder: folderWithLevel.folder, level: folderWithLevel.level)
                        }
                    }
                }// end of List
            } else {
                List(fastFolderWithLevelGroup.archives, id: \.self)  { folderWithLevel in
                    Button {
                        folderEditVM.folderToPaste = folderWithLevel.folder
                        
                        if folderEditVM.folderToCut != nil {
                            if Folder.convertLevelIntoFolder(invalidFolderWithLevels).contains(folderEditVM.folderToPaste!) {
                                folderEditVM.folderToCut = nil
                            } else {
                                folderEditVM.folderToPaste?.add(subfolder: folderEditVM.folderToCut!)
                                msgToShow = Messages.showFolderMovedMsg(targetFolder: folderEditVM.folderToCut!, to: folderEditVM.folderToPaste!)
                                folderEditVM.folderToCut!.modificationDate = Date()
                                
//                                isValidAction = true
                            }
                        } else {
                             memoEditVM.selectedMemos.forEach { folderEditVM.folderToPaste!.add(memo: $0)
                                $0.modificationDate = Date()
                                msgToShow = Messages.showMemoMovedMsg(memoEditVM.count, to: folderEditVM.folderToPaste!)
                            }
                            
//                            isValidAction = true
                            
                            memoEditVM.initSelectedMemos()
                        }
                        
                        folderEditVM.folderToPaste = nil
                        
                        context.saveCoreData()
                        
                        folderEditVM.folderToPaste = nil
                        
//                        if isValidAction {
//                            dismissAction()
//                        }
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        
                        if invalidFolderWithLevels.contains(folderWithLevel) {
                            CheckableFolderCell(folder: folderWithLevel.folder, level: folderWithLevel.level, markInvalid: true)
                                .background(.red)
                            
//                        } else if folderWithLevel.folder == folderEditVM.folderToCut || folderWithLevel.folder == memoEditVM.parentFolder{
                        } else if folderWithLevel.folder == folderEditVM.folderToCut || memoEditVM.folderRelated.contains(folderWithLevel.folder){
                            CheckableFolderCell(folder: folderWithLevel.folder, level: folderWithLevel.level, markCheck: true)
                        } else {
                            CheckableFolderCell(folder: folderWithLevel.folder, level: folderWithLevel.level)
                        }
                    }
                }// end of List
            }
        }
        .onAppear{
            print("invalidFolderWithLevels : \(invalidFolderWithLevels)")
        }
        
        .onDisappear {
            UIView.setAnimationsEnabled(true)
            if shouldUpdateTopFolder {
                //
            Folder.updateTopFolders(context: context)
            }
        }
        .navigationBarHidden(true)
    }
}
