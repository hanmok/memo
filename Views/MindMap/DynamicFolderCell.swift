//
//  FastVerCollapsibleFolder.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI
import CoreData

struct DynamicFolderCell: View {
    
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
//    @ObservedObject var trashBin: Folder
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @ObservedObject var folder: Folder
    
    @State var showingDeleteAction = false
    
    var level: Int
    
    var body: some View {
        NavigationLink(destination: FolderView(currentFolder: folder)
                        .environmentObject(memoEditVM)
                        .environmentObject(folderEditVM)
                        .environmentObject(memoOrder)
                        .environmentObject(trashBinVM)
        ) {
            TitleWithLevelView(folder: folder, level: level)
        } // end of NavigationLink
    }
}

class TrashBinViewModel: ObservableObject {
    @Published var trashBinFolder: Folder
    init(trashBinFolder: Folder) {
        self.trashBinFolder = trashBinFolder
    }
}

struct TrashBinCell: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM : FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    var body: some View {
        NavigationLink(destination: TrashFolderView()
                        .environmentObject(folderEditVM)
                        .environmentObject(memoOrder)
                        .environmentObject(memoEditVM)
                        .environmentObject(trashBinVM)
        ) {
            HStack {
                Text("Trash Bin").foregroundColor(.red)
                Spacer()
                Text("\(trashBinVM.trashBinFolder.memos.count)")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


struct TrashBinView: View {
    @ObservedObject var folder: Folder
    
    var body: some View {
        Text(folder.title)
    }
}
