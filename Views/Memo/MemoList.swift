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
                
                FilteredMemoList(folder: folder, listType: .pinned)
//                FilteredMemoList(memosViewModel: MemosViewModel(folder: folder, type: .pinned))
                
                // line between pinned / unpinned memos
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
                    .padding(.top, 5)
            }
            
            FilteredMemoList(folder: folder, listType: .unpinned)
//            FilteredMemoList(memosViewModel: MemosViewModel(folder: folder, type: .unpinned))
        } // end of VStack
        .environmentObject(memoEditVM)
        .environmentObject(folderEditVM)
    }
}

// 테두리.. 
