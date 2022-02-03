////
////  SubFoldersToolView.swift
////  DeeepMemo
////
////  Created by Mac mini on 2022/01/10.
////
//
//import SwiftUI
//
//// has close connection to SubFolderPageView (editing, collapsing)
//
//// 버튼 : 생성, 이름 편집, 위치 편집, 제거
//// 생성 외 다른 버튼들은 하나로 묶을 수 있을 것 같은데 ?
//
//struct SubFoldersToolView: View {
//
//    let imageSizes : CGFloat = 24
//    @EnvironmentObject var folderEditVM: FolderEditViewModel
//
//    //    @ObservedObject var currentFolder: Folder
//    @EnvironmentObject var currentFolder: Folder
//    @Environment(\.managedObjectContext) var context
//
//    //    @State var shouldAddFolder = false
////    @Binding var shouldAddSubfolder: Bool
//    @Binding var shouldHideSubFolderView: Bool
//    //    @State var newSubFolderName = ""
//
//    func addFolder() {
////        shouldAddSubfolder = true
//        folderEditVM.shouldAddFolder = true
//    }
//
//    func changeFolderName() {
//
//    }
//
//    func deleteFolder() {
//
//    }
//
//    func expandList() {
//
//    }
//
//    func hideSubFolderView() {
//        shouldHideSubFolderView.toggle()
////        folderEditVM.shouldHideSubFolders.toggle() // 이거 .. 같은데 ?
//        // 여기서 이 값을 바꾸면, 해당 값을 사용하고 있는 다른 View. 에서 update 가 일어나서 해당 view 로 이동하는거 아닐까 ?
//        // 그렇다면, shouldHide property 는 State 이어야 하지 않을까 ?
//    }
//
//    func editSubfolders() {
//
//    }
//
//    var body: some View {
//        ZStack {
//            HStack {
//                if !shouldHideSubFolderView {
////                if !folderEditVM.shouldHideSubFolders {
//                    Button(action: addFolder) {
//                        ChangeableImage(imageSystemName: "folder.badge.plus", width: imageSizes + 4, height: imageSizes + 4)
//                    }
//                    .padding(.horizontal, Sizes.minimalSpacing)
//
////                    Button(action: editSubfolders) {
////                        ChangeableImage(imageSystemName: "gear", width: imageSizes, height: imageSizes)
////                    }
////                    .padding(.leading, Sizes.minimalSpacing)
//
//                }
//                Button(action: hideSubFolderView, label: {
//
//                    if shouldHideSubFolderView {
//                        HStack {
//                            ChangeableImage(imageSystemName: "folder", width: imageSizes , height: imageSizes )
//                                .padding(.horizontal, Sizes.minimalSpacing)
//
//                        ChangeableImage(imageSystemName:  "chevron.up" , width: imageSizes - 6, height: imageSizes - 6)
//                                .padding(.leading, Sizes.minimalSpacing)
////                                .padding(.trailing, Sizes.overallPadding)
//                        }
//                    } else {
//                        ChangeableImage(imageSystemName:  "chevron.down" , width: imageSizes - 6, height: imageSizes - 6)
//                    }
//                })
//                    .padding(.leading, Sizes.minimalSpacing)
//                    .padding(.trailing, Sizes.overallPadding)
//            }
//        }
//    }
//}
//
//
//
////struct SubFoldersToolView_Previews: PreviewProvider {
////    static var previews: some View {
////        SubFoldersToolView()
////    }
////}
