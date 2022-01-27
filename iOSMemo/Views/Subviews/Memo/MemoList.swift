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

    func makeNewMemo() {
        memoEditVM.shouldAddMemo = true
    }
    
    var pinnedMemos: [Memo] {
        return folder.memos.filter { $0.pinned == true}
    }
    var unpinnedMemos: [Memo] {
        return folder.memos.filter { $0.pinned == false }
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        
        return VStack {
            VStack {
                if pinnedMemos.count != 0 {
                    FilteredMemoList(memos: pinnedMemos, title: "pinned", parent: folder)
                    // line between pinned / unpinned memos
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
                }
                
                FilteredMemoList(memos: unpinnedMemos, title: "unpinned", parent: folder)
            } // end of VStack
        }
    }
}
