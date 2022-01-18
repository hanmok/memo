//
//  SubFoldersToolView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/10.
//

import SwiftUI

// has close connection to SubFolderPageView (editing, collapsing)

// 버튼 : 생성, 이름 편집, 위치 편집, 제거
// 생성 외 다른 버튼들은 하나로 묶을 수 있을 것 같은데 ?

struct SubFoldersToolView: View {
    
    let imageSizes : CGFloat = 24
    
    //    @ObservedObject var currentFolder: Folder
    @EnvironmentObject var currentFolder: Folder
    @Environment(\.managedObjectContext) var context
    
    //    @State var shouldAddFolder = false
    @Binding var shouldAddSubfolder: Bool
    //    @State var newSubFolderName = ""
    
    func addFolder() {
        shouldAddSubfolder = true
    }
    
    func changeFolderName() {
        
    }
    func changeSort() {
        
    }
    func deleteFolder() {
        
    }
    func expandList() {
        
    }
    
    func hideSubFolderView() {
        
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: addFolder) {
                    ChangeableImage(imageSystemName: "folder.badge.plus", width: imageSizes + 4, height: imageSizes + 4)
                }
                .padding(.horizontal, Sizes.minimalSpacing)
                
                // original Buttons
                //                Button(action: changeFolderName) {
                //                    ChangeableImage(imageSystemName: "pencil", width: imageSizes, height: imageSizes)
                //                }
                //                .padding(.horizontal, Sizes.minimalSpacing)
                //                Button(action: changeSort) {
                //                    ChangeableImage(imageSystemName: "arrow.up.and.down.circle", width: imageSizes, height: imageSizes)
                //
                //                }
                //                .padding(.horizontal, Sizes.minimalSpacing)
                //                Button(action: deleteFolder) {
                //                    ChangeableImage(imageSystemName: "trash", width: imageSizes, height: imageSizes)
                //                }
                //
                //                .padding(.leading, Sizes.minimalSpacing)
                //                .padding(.trailing, Sizes.overallPadding)
                
                Button(action: deleteFolder) {
                    ChangeableImage(imageSystemName: "gear", width: imageSizes, height: imageSizes)
                }
                
                .padding(.leading, Sizes.minimalSpacing)
                
                Button(action: hideSubFolderView, label: {
                    ChangeableImage(imageSystemName: "chevron.right", width: imageSizes - 6, height: imageSizes - 6)
                })
                    .padding(.leading, Sizes.minimalSpacing)
                    .padding(.trailing, Sizes.overallPadding)
                
                
                //                Button(action: expandList) {
                //                    ChangeableImage(imageSystemName: "chevron.down")
                //                }
                //                .padding(.horizontal, Sizes.minimalSpacing)
            }
            //            TextFieldAlert(
            //                isPresented: $shouldAddFolder,
            //                text: $newSubFolderName) { text in
            //                currentFolder.add(subfolder: currentFolder)
            //            }
        }
        
        
        
    }
}



//struct SubFoldersToolView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubFoldersToolView()
//    }
//}
