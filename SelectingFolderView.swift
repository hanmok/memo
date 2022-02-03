//
//  SelectingFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/28.
//

import SwiftUI
import CoreData

struct SelectingFolderView: View {
    
    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var memoEditViewModel: MemoEditViewModel
    @EnvironmentObject var folderEditViewModel: FolderEditViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        return VStack {
            
            Text("Select Folder ")
                .padding(.leading, Sizes.overallPadding)
                .padding(.vertical)
            
            List(fastFolderWithLevelGroup.allFolders) { folderWithLevel in
                if folderWithLevel != fastFolderWithLevelGroup.allFolders.last {
                    
                    Button {
                        
                        folderEditViewModel.folderToPaste = folderWithLevel.folder
                        
                        if folderEditViewModel.folderToCut != nil {
                        folderEditViewModel.folderToPaste!.add(subfolder: folderEditViewModel.folderToCut!)
                        }
                        context.saveCoreData()
                        
                        folderEditViewModel.folderToCut = nil
                        folderEditViewModel.folderToPaste = nil
                        
                        Folder.updateTopFolders(context: context)
                        
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        SelectingCollapsibleFolder(folder: folderWithLevel.folder, level: folderWithLevel.level)
                    }
                }
            } // end of List
        }
    }
}



struct SelectingCollapsibleFolder: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var folder: Folder
    
    var level: Int
    var numOfSubfolders: String{
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        HStack {
            ForEach(0 ..< level + 1) { _ in
                Text("  ")
            }
            
            Text(folder.title)
                .foregroundColor(colorScheme.adjustTint())
            
            if folder.isFavorite {
                Text(Image(systemName: "star.fill"))
                    .tint(.yellow) // why not working ?
            }
            
            EmptyView()
                .background(.white)
        }
    }
    
}
