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
        VStack(spacing: 0) {
            ChangeableImage(colorScheme: _colorScheme, imageSystemName: "folder", width: 32, height: 32)
                .padding(.bottom, 5)
            Text(folder.title)
                .font(.body)
                .lineLimit(2)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        } // aspectRatio: width / height
        .aspectRatio(1, contentMode: .fit)
    }
}

//struct FolderLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderLabelView()
//    }
//}
