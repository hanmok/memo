//
//  SubFolderButtonImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/04.
//

import SwiftUI

struct SubFolderButtonImage: View {
    var body: some View {
        ZStack {
            ChangeableImage(imageSystemName: "circle", width: 50, height: 50)
                .foregroundColor(.green)
                .background(.green)
                .clipShape(Circle())
            ChangeableImage(imageSystemName: "folder")
                .frame(width: 25, height: 25)
                .foregroundColor(.black)
        }
    }
}
