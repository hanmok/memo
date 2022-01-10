//
//  FolderLabelView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/07.
//

import SwiftUI

struct FolderLabelView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let folder: Folder
    
    var body: some View {
        VStack {
            ChangeableImage(colorScheme: _colorScheme, imageSystemName: "folder", width: 20, height: 20)
            Text(folder.title)
        }
    }
}

//struct FolderLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderLabelView()
//    }
//}
