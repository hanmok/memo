//
//  SubFoldersTestView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/10.
//

import SwiftUI
import CoreData

struct ChangeFolderTitleTestView: View {
    @Environment(\.managedObjectContext) var context
    let folder: Folder
    @State private var folderName: String = ""
    
    func saveChange() {
        folder.title = folderName
        context.saveCoreData()
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            TextField(folder.title, text: $folderName)
                .onDisappear {
                    saveChange()
                }
                .onSubmit {
                    saveChange()
                }
            
            Spacer()
        }
        
        
    }
}

struct ChangeFolderTitleTestView_Previews: PreviewProvider {
    
    static var sampleFolder = Folder(title: "sample Folder", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        ChangeFolderTitleTestView(folder: sampleFolder)
    }
}
