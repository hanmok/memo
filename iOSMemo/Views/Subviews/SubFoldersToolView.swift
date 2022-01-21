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
    @Binding var shouldHideSubFolderView: Bool
    //    @State var newSubFolderName = ""
    
    func addFolder() {
        shouldAddSubfolder = true
    }
    
    func changeFolderName() {
        
    }
    
    func deleteFolder() {
        
    }
    
    func expandList() {
        
    }
    
    func hideSubFolderView() {
        shouldHideSubFolderView.toggle()
    }
    
    func editSubfolders() {
        
    }
    
    var body: some View {
        ZStack {
            HStack {
                if !shouldHideSubFolderView {
                    Button(action: addFolder) {
                        ChangeableImage(imageSystemName: "folder.badge.plus", width: imageSizes + 4, height: imageSizes + 4)
                    }
                    .padding(.horizontal, Sizes.minimalSpacing)
                    
                    Button(action: editSubfolders) {
                        ChangeableImage(imageSystemName: "gear", width: imageSizes, height: imageSizes)
                    }
                    
                    .padding(.leading, Sizes.minimalSpacing)
                    
                }
                
                Button(action: hideSubFolderView, label: {
//                    ChangeableImage(imageSystemName: "chevron.bottom", width: imageSizes - 6, height: imageSizes - 6)
//                        .background(.red)
                        
                    
                    ChangeableImage(imageSystemName: shouldHideSubFolderView ? "chevron.up" : "chevron.down", width: imageSizes - 6, height: imageSizes - 6)
                })
                    .padding(.leading, Sizes.minimalSpacing)
                    .padding(.trailing, Sizes.overallPadding)
//                    .rotationEffect(shouldHideSubFolderView ?  .degrees(180) : .degrees(0))
                
                
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
