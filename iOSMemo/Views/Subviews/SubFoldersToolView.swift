//
//  SubFoldersToolView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/10.
//

import SwiftUI

// has close connection to SubFolderPageView (editing, collapsing)

struct SubFoldersToolView: View {
    

    
    //    @ObservedObject var currentFolder: Folder
    @EnvironmentObject var currentFolder: Folder
    @Environment(\.managedObjectContext) var context
    
    @State var shouldAddFolder = false
    @State var newSubFolderName = ""
    
    func addFolder() {
        shouldAddFolder = true
    }
    
    func changeFolderName() {
        
    }
    func changeSort() {
        
    }
    func deleteFolder() {
        
    }
    func expandList() {
        
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: addFolder) {
                    ChangeableImage(imageSystemName: "folder.badge.plus")
                }
                .padding(.horizontal, Sizes.minimalSpacing)
                Button(action: changeFolderName) {
                    ChangeableImage(imageSystemName: "pencil")
                }
                .padding(.horizontal, Sizes.minimalSpacing)
                Button(action: changeSort) {
                    ChangeableImage(imageSystemName: "arrow.up.and.down.circle")
                    
                }
                .padding(.horizontal, Sizes.minimalSpacing)
                Button(action: deleteFolder) {
                    ChangeableImage(imageSystemName: "trash")
                }
                .padding(.horizontal, Sizes.minimalSpacing)
                Button(action: expandList) {
                    ChangeableImage(imageSystemName: "chevron.down")
                }
                .padding(.horizontal, Sizes.minimalSpacing)
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
