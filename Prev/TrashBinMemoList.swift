////
////  TrashBinMemoList.swift
////  DeeepMemo (iOS)
////
////  Created by Mac mini on 2022/03/03.
////
//
//import SwiftUI
//
//struct TrashBinMemoList: View {
//
//    @EnvironmentObject var trashBinVM: TrashBinViewModel
//
//    var body: some View {
//        return VStack {
//            FilteredMemoList(folder: trashBinVM.trashBinFolder, listType: .all)
//        } // end of VStack
//        .environmentObject(trashBinVM)
//    }
//}
