//
//  MemosToolBarView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/28.
//

import SwiftUI
// need connection to FolderView.
// maybe.. onReive necessary.
struct MemosToolBarView: View {
    let spacingBetweenButtons: CGFloat = 12
    var body: some View {
        HStack(spacing: spacingBetweenButtons) {
            VStack(spacing: spacingBetweenButtons) {
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "pin",width: 20, height: 20)
                }
                .padding(5)
//                .background(Color(.sRGB, white: 0.9))
                .cornerRadius(5)
                
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "doc.on.doc",width: 20, height: 20)
                }
                    .padding(5)
//                    .background(Color(.sRGB, white: 0.9))                    .cornerRadius(5)
            }
            
            VStack(spacing: spacingBetweenButtons) {
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "eyedropper.halffull",width: 20, height: 20)
                }
                .padding(5)
//                .background(Color(.sRGB, white: 0.9))
                .cornerRadius(5)

                Button(action: {}) {
                    ChangeableImage(imageSystemName: "trash", width: 20, height: 20)
                }
                .padding(5)
//                .background(Color(.sRGB, white: 0.9))
                .cornerRadius(5)
            }
        }
        .padding(10)
//        .background(Color(.sRGB, white: 0.5, opacity: 0.5))
        .cornerRadius(10)
    }
}

struct MemosToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        MemosToolBarView()
            .previewLayout(.sizeThatFits)
    }
}
