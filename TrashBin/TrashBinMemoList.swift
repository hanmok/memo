//
//  TrashBinMemoList.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI

struct TrashBinMemoList: View {
    
    @EnvironmentObject var folder: Folder
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        return VStack {
            
            TrashBinSubMemoList(folder: trashBinVM.trashBinFolder)
        } // end of VStack
        .environmentObject(memoEditVM)
        .environmentObject(folderEditVM)
        .environmentObject(trashBinVM)
    }
}
