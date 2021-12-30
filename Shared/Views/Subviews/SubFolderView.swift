//
//  SubFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct SubFolderView: View {
    var subfolder: Folder
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: FolderView(folder: subfolder),
                label: {
                    Text(subfolder.title)
                })
        }
        
        .padding(.horizontal, Sizes.overallPadding)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, maxHeight: 30)
    }
}

struct SubFolderView_Previews: PreviewProvider {
    static var previews: some View {
        SubFolderView(subfolder: folder2)
    }
}
