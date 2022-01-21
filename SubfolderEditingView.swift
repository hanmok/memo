//
//  SubfolderEditingView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/21.
//

import SwiftUI

struct SubfolderEditingView: View {
    @ObservedObject var folder: Folder
    
    var body: some View {
        List(convertSetToArray(set: folder.subfolders)) { eachFolder in
            Text(eachFolder.title)
        }
    }
}

//struct SubfolderEditingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubfolderEditingView()
//    }
//}
