//
//  FolderLabelView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/07.
//

import SwiftUI

struct FolderLabelView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var folder: Folder
    
    var body: some View {
        VStack {
            ChangeableImage(colorScheme: _colorScheme, imageSystemName: "folder", width: 40, height: 40)
//            Image(systemName: "folder")
//                .resizable()
//                .aspectRatio(1, contentMode: .fit)
//                .frame(width: 40, height: 40)
//                .tint(.black)
            Text(folder.title)
                .font(.body)
                .lineLimit(2)
        } // aspectRatio: width / height
        .aspectRatio(0.8, contentMode: .fit)
    }
}

//struct FolderLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderLabelView()
//    }
//}
