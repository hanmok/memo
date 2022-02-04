//
//  TItleWithLavelView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/01.
//

import SwiftUI

struct TitleWithLevelView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject var folder: Folder
    
    var level: Int

    
    var body: some View {
        HStack {
            ForEach( 0 ..< level + 1) { _ in
                Text("  ")
            }
            
            Text(folder.title)
                .foregroundColor(colorScheme.adjustTint())
            
            if folder.isFavorite {
                Text(Image(systemName: "star.fill"))
                    .tint(.yellow) // why not working ?
            }
        }
    }
}

//struct TItleWithLavelView_Previews: PreviewProvider {
//    static var previews: some View {
//        TItleWithLavelView()
//    }
//}