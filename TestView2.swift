////
////  TestView2.swift
////  DeeepMemo
////
////  Created by Mac mini on 2022/01/28.
////
//
//import SwiftUI
//
//struct TestView2: View {
//
//    @StateObject var memoEditViewModel = MemoEditViewModel()
//    @StateObject var folderEditViewModel = FolderEditViewModel()
//
//    @ObservedObject var fastFolderWithLevelGroup: FastFolderWithLevelGroup
//    @ObservedObject var folder: Folder
//
//    var body: some View {
//
//        let sorted = folder.subfolders.sorted()
//
//        return VStack(spacing: 10) {
//        List(sorted) { mysubfolder in
////            if subfolder == folder.subfolders.sorted().first
//                    Text( mysubfolder.title)
//                .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                    Button(action: {
//                        print(sorted.count)
//                        for each in sorted {
//                            print(each.title)
//                        }
//                    }) {
//                        Text("hello")
//                    }
//                }
//                }
//        
//            List(fastFolderWithLevelGroup.allFolders) { folderWithLevel in
////                Text(subFolder.folder.title)
//
//
//
//                FastVerCollapsibleFolder(folder: folderWithLevel.folder)
//                    .environmentObject(memoEditViewModel)
//                    .environmentObject(folderEditViewModel)
//                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                        Button(action: {
//                            print(sorted.count)
//                            for each in sorted {
//                                print(each.title)
//                            }
//                        }) {
//                            Text("hello")
//                        }
//                    }
//
//                }
//        }
//            }
//    }
////        }
//
//
//
////struct TestView2_Previews: PreviewProvider {
////    static var previews: some View {
////        TestView2()
////    }
////}
