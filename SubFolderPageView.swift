//
//  SUbFolderPageView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/07.
//

import SwiftUI

struct SubFolderPageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let folder: Folder
    var subfolders: [Folder] {
        //        return folder.subfolders
        // need to make Folders into array first.
        let sortedOldFolders = folder.subfolders.sorted()
        return sortedOldFolders
    }
    
    func createNewFolder() {
        
    }
    func deleteSubFolder() {
        
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            ForEach(subfolders) { subfolder in
                HStack {
                    FolderLabelView(folder: folder)
                }
            }
        }
        .overlay {
            VStack {
                
                HStack {
                    Spacer()
                    Menu {
                        Button(action: createNewFolder) {
                            Label {
                                Text("Create")
                            } icon: {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        Button(action: deleteSubFolder) {
                            Label {
                                Text("Delete")
                            } icon: {
                                Image(systemName: "trash.fill")
                            }
                        }
                        // sort menu
//                        Menu(content: <#T##() -> _#>, label: <#T##() -> _#>)
                        
                    } label: {
                        ChangeableImage(colorScheme: _colorScheme, imageSystemName: "ellipsis.circle", width: 20, height: 20)
                    }

                }
                Spacer()
            }
        }
    }
}

//struct SubFolderPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubFolderPageView()
//    }
//}


