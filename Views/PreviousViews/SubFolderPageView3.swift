////
////  SUbFolderPageView.swift
////  DeeepMemo
////
////  Created by Mac mini on 2022/01/07.
////
//
//import SwiftUI
//
//struct SubFolderPageView3: View {
//
//    @Environment(\.colorScheme) var colorScheme
//
////    @ObservedObject var folder: Folder
//    @EnvironmentObject var currentFolder: Folder
//    @Binding var shouldAddSubFolder: Bool
//    @Binding var shouldHideSubFolderView: Bool
//
//    var subfolders: [Folder] {
//        let sortedOldFolders = currentFolder.subfolders.sorted()
//
//        return sortedOldFolders
//    }
//
//    var body: some View {
//        // MARK: - SubFolder List
//        VStack(spacing: 0) {
//            HStack {
//                Spacer()
//                SubFoldersToolView(
////                    shouldAddSubfolder: $shouldAddSubFolder,
////                    shouldHideSubFolderView: $shouldHideSubFolderView
//                )
//                //                Color(.white)
//            }
//            // show SubFolderView
//            if !shouldHideSubFolderView {
//                ScrollView(.horizontal) {
//                    HStack {
//                        if subfolders.count != 0 {
//                            ForEach(subfolders) { subfolder in
//                                // navigationLink 문제가 아니라, nav 문제일듯.
//
//                                NavigationLink(
//                                    destination: FolderView(currentFolder: subfolder)) {
//                                        FolderLabelView3(folder: subfolder)
//                                            .frame(width:50, height: 50)
//                                    }
//                                    .onAppear(perform: {
//                                        print("title of subFolder: \(subfolder.title)")
//                                    })
//                                    .onTapGesture {
//                                        print("tapped !! \(subfolder.title)")
//                                    }
//
//                                    .padding(.horizontal, Sizes.overallPadding)
//                                    .padding(.top, Sizes.minimalSpacing * 4)
//
//                            } // end of ForEach.
//                        } else { // subfolder.count == 0
////                            HStack(alignment: .center, spacing: 3) {
//                            HStack(spacing: 3) {
//
//                                Text("press   ")
//                                ChangeableImage(imageSystemName: "folder.badge.plus", width: 26, height: 26)
//                                Text("   to make a subFolder")
//                                    .frame(maxWidth: .infinity)
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .font(.title3)
//                            .padding(.horizontal, Sizes.overallPadding)
//                            .padding(.top, Sizes.minimalSpacing * 4)
////                            .background(.green)
//                        }
//
//                }
//                .padding(.bottom, 10)
////                }
//            } // end of horizontal ScrollView
//            }
//            //            }
//        }
//        // scroll to the right when subfolder added
//        //        .onReceive(folder, perform: <#T##(Publisher.Output) -> Void#>)
//
//        //        .background(Color.blue)
//        // Tool bar on the top
//        //        .overlay {
//        //            HStack {
//        //                Spacer()
//        //                VStack {
//        //                    SubFoldersToolView()
//        //                    Spacer()
//        //                }
//        //            }
//        ////            .background(.yellow)
//        //        }
//    }
//}
//
//
//struct SubFolderPageView_Previews: PreviewProvider {
//
//    static var testFolder = Folder(title: "test Folder", context: PersistenceController.preview.container.viewContext)
//
//    static var previews: some View {
////        SubFolderPageView(folder: testFolder)
//        SubFolderPageView3( shouldAddSubFolder: .constant(false), shouldHideSubFolderView: .constant(true))
//            .environmentObject(testFolder)
//    }
//}
//
