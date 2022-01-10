//
//  SubFoldersTestView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/10.
//

import SwiftUI
import CoreData

struct SubFoldersTestView: View {
    @Environment(\.managedObjectContext) var context
    let folder: Folder
    @State private var folderName: String = ""
//    var subFolders: [Folder] {
//        return folder.subfolders.sorted()
//    }
    var body: some View {
//        ForEach(subFolders) { eachFolder in
//            Text(eachFolder.title)
//        }
//        TextField(folder.title, $folderName)
        TextField(folder.title, text: $folderName)
            .onDisappear {
                folder.title = folderName
                context.saveCoreData()
            }
    }
}

//struct SubFoldersTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubFoldersTestView()
//    }
//}
