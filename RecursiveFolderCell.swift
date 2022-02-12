//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData
struct RecursiveFolderCell: View {
    
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @ObservedObject var folder: Folder
    
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        return ZStack(alignment: .leading) {
            NavigationLink(destination: FolderView(currentFolder: folder)
                            .environmentObject(memoEditVM)
                            .environmentObject(folderEditVM)
            ) {
                EmptyView()
            } // end of NavigationLink
            FolderTitleWithStar(folder: folder)
        }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                // REMOVE !
                Button {
                    context.saveCoreData()
                } label: {
                    ChangeableImage(imageSystemName: "trash")
                }
                .tint(.red)
                // CHANGE FOLDER NAME
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                Button {
                    context.saveCoreData()
                } label: {
                    ChangeableImage(imageSystemName: "pencil")
                }
                .tint(.red)
            }
    }
}



struct FolderTitleWithStar: View {
    @ObservedObject var folder: Folder
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        HStack {
            Text(folder.title)
                .foregroundColor(colorScheme.adjustBlackAndWhite())
            
            if folder.isFavorite {
                Text(Image(systemName: "star.fill"))
                    .tint(.yellow) // why not working ?
            }
        }
    }
}
