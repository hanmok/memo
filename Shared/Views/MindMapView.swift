//
//  MindMapView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

struct MindMapView: View {
    var homeFolder: Folder
    @State private var shouldNavigate: Bool = false
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
                HorCollapsibleMind(folder: homeFolder)
        }
    }
}

struct MindMapView_Previews: PreviewProvider {
    static var previews: some View {
        MindMapView(homeFolder: deeperFolder)
    }
}
