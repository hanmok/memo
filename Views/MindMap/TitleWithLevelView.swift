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
    
    let level: Int
    
    var shouldHideArrow = false
    
    var body: some View {
        HStack {
            ForEach(0 ..< level, id: \.self) { _ in
                Text("  ") // double Space for each level
            }
            
            Text(folder.title)
                .foregroundColor(Color.blackAndWhite)
            
            Spacer()
            Text("\(folder.memos.count)")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
