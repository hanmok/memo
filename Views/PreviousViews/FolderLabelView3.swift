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
//        HStack {
//            Text(Image(systemName: "folder")) + Text(folder.title)
//        }
//        .font(.title3)
//        .tint(colorScheme == .dark ? .white : .black)
//        .frame(maxWidth: .infinity, alignment: .leading)
        
        
        VStack(alignment: .center) {
                Text(Image(systemName: "folder"))
                    .font(.subheadline)
                + Text("  ")
                + Text(folder.title)
                    .font(.title3)
        }
            .tint(colorScheme == .dark ? .white : .black)
            
            .frame(maxWidth: .infinity, alignment: .leading)
            
    }
}

//struct FolderLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderLabelView()
//    }
//}



struct FolderLabelView3: View {
    
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

//struct FolderLabelView3_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderLabelView()
//    }
//}


