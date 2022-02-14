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
//    @State var invalidFolderWithLevels: [FolderWithLevel] = []
    var invalidFolderWithLevels: [FolderWithLevel]

    @State var selectionEnum = FolderTypeEnum.folder // default value

//    var onSubmitAction: () -> Void = { }
//    var onCancelAction: () -> Void = { }
    var isFullScreen: Bool = false
  
    var body: some View {
        
//        if folderEditVM.folderToCut != nil {
//            DispatchQueue.main.async {
////                invalidFolderWithLevels = Folder.getHierarchicalFolders(topFolders: [folderEditVM.folderToCut!])
//                invalidFolderWithLevels = Folder.getHierarchicalFolders(topFolder: folderEditVM.folderToCut!)
//                for each in invalidFolderWithLevels {
//                    print("invalidFolder: \(each.folder.title)")
//                }
//            }
//        }
        
        
        return VStack(spacing: 0) {
            HStack {
                Spacer()
                HStack {
                    Text("Select Folder ")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // MARK: - FOR TESTING
                    Button {
                        _ = invalidFolderWithLevels.map { print("invalidFolder: \($0.folder.title)")}
//                        for each in invalidFolderWithLevels {
//                            print("invalidFolder: \(each.folder.title)")
//                        }
                        
                    } label: {
                        ChangeableImage(imageSystemName: "star")
                    }
                    
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        folderEditVM.folderToCut = nil
                        memoEditVM.initSelectedMemos() // ?? should it be ?  yes.
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
                List(fastFolderWithLevelGroup.folders, id: \.self)  { folderWithLevel in
                    Button {
                        folderEditVM.folderToPaste = folderWithLevel.folder
                        
                        if folderEditVM.folderToCut != nil {
                            if Folder.convertLevelIntoFolder(invalidFolderWithLevels).contains(folderEditVM.folderToPaste!) {
                                folderEditVM.folderToCut = nil
                            } else {
                                folderEditVM.folderToPaste?.add(subfolder: folderEditVM.folderToCut!)
                            }
                        } else {
                            _ = memoEditVM.selectedMemos.sorted().map { folderEditVM.folderToPaste!.add(memo: $0)}
//                            for eachMemo in memoEditVM.selectedMemos.sorted() {
//                                folderEditVM.folderToPaste!.add(memo: eachMemo)
//                            }
                            
                            memoEditVM.initSelectedMemos()
                        }
                        folderEditVM.folderToPaste = nil
                        presentationMode.wrappedValue.dismiss()
                        
                        context.saveCoreData()
                        
                        folderEditVM.folderToPaste = nil
        
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        
                        if invalidFolderWithLevels.contains(folderWithLevel) {
                            TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                                .background(.red)
                            
                        } else if folderWithLevel.folder == folderEditVM.folderToCut || folderWithLevel.folder == memoEditVM.parentFolder{
                            TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                                .tint(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.8))
                                .background(colorScheme.adjustSubColors())
                        } else {
                            TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
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
                            }
                        } else {
                            _ = memoEditVM.selectedMemos.sorted().map { folderEditVM.folderToPaste!.add(memo: $0)}
//                            for eachMemo in memoEditVM.selectedMemos.sorted() {
//                                folderEditVM.folderToPaste!.add(memo: eachMemo)
//                            }
                            memoEditVM.initSelectedMemos()
                        }
                        folderEditVM.folderToPaste = nil
                        presentationMode.wrappedValue.dismiss()
                        
                        context.saveCoreData()
                        
                        folderEditVM.folderToPaste = nil
        
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        
                        if invalidFolderWithLevels.contains(folderWithLevel) {
                            TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                                .background(.red)
                            
                        } else if folderWithLevel.folder == folderEditVM.folderToCut || folderWithLevel.folder == memoEditVM.parentFolder{
                            TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
                                .tint(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.8))
                                .background(colorScheme.adjustSubColors())
                        } else {
                            TitleWithLevelView(folder: folderWithLevel.folder, level: folderWithLevel.level)
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
            
        }
        .navigationBarHidden(true)
    }
}
