//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct MemoList: View {
    
    @EnvironmentObject var folder: Folder
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
//    @ObservedObject var trashBinFolder: Folder
    @EnvironmentObject var trashBinVM: TrashBinViewModel
//    var hasPinnedMemo: Bool {
//        return folder.memos.contains { $0.pinned == true }
//    }
    
    var hasPinnedMemo: Bool {
        return folder.memos.contains { $0.pinned == true || $0.isBookMarked == true}
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        return VStack {
            
            if hasPinnedMemo {
                
//                FilteredMemoList(folder: folder, listType: .pinned)
//                FilteredMemoList(folder: folder, memosVM: MemosViewModel(folder: folder, type: .pinned), listType: .pinned)
//                FilteredMemoList(trashBinFolder: trashBinFolder, folder: folder, listType: .pinned)
                FilteredMemoList(folder: folder, listType: .pinned)
                
                // line between pinned / unpinned memos
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
                    .padding(.top, 5)
            }
            
//            FilteredMemoList(trashBinFolder: trashBinFolder, folder: folder, listType: .unpinned)
            FilteredMemoList(folder: folder, listType: .unpinned)
//            FilteredMemoList(folder: folder, memosVM: MemosViewModel(folder: folder, type: .unpinned), listType: .unpinned)
        } // end of VStack
        .environmentObject(memoEditVM)
        .environmentObject(folderEditVM)
        .environmentObject(trashBinVM)
    }
}

// 테두리.. 







//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct TrashBinMemoList: View {
    
    @EnvironmentObject var folder: Folder
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel

    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    var hasPinnedMemo: Bool {
        return trashBinVM.trashBinFolder.memos.contains { $0.pinned == true || $0.isBookMarked == true}
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        return VStack {
            
            if hasPinnedMemo {
                
                FilteredMemoList(folder: trashBinVM.trashBinFolder, listType: .pinned)
                
                // line between pinned / unpinned memos
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
                    .padding(.top, 5)
            }
                        FilteredMemoList(folder: trashBinVM.trashBinFolder, listType: .unpinned)
        } // end of VStack
        .environmentObject(memoEditVM)
        .environmentObject(folderEditVM)
        .environmentObject(trashBinVM)
    }
}

// 테두리..
