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
    @EnvironmentObject var allMemosVM: AllMemosViewModel
    
    var hasPinnedMemo: Bool {
        return folder.memos.contains { $0.pinned == true }
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        return VStack {
            
            if hasPinnedMemo {
                
                FilteredMemoList(folder: folder, listType: .pinned)
//                    .environmentObject(allMemosVM)
                
                // line between pinned / unpinned memos
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
            }
            
            FilteredMemoList(folder: folder, listType: .unpinned)
//                .environmentObject(allMemosVM)
        } // end of VStack
        .onAppear(perform: {
            print("memoList has appeared!")
//            allMemosVM.targetFolder = folder
        })
        .environmentObject(memoEditVM)
    }
}

