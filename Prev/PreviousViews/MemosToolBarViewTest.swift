//
//  MemosToolBarView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/28.
//

import SwiftUI
// need connection to FolderView.
// maybe.. onReive necessary.
struct MemosToolBarViewTest: View {
    let spacingBetweenButtons: CGFloat = 12
    var body: some View {
        HStack(spacing: spacingBetweenButtons) {
            
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "pin",width: 20, height: 20)
                }
                .padding(5)
                .cornerRadius(5)
                
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "doc.on.doc",width: 20, height: 20)
                }
                    .padding(5)

                Button(action: {}) {
                    ChangeableImage(imageSystemName: "eyedropper.halffull",width: 20, height: 20)
                }
                .padding(5)
                .cornerRadius(5)

                Button(action: {}) {
                    ChangeableImage(imageSystemName: "trash", width: 20, height: 20)
                }
                .padding(5)
                .cornerRadius(5)
        }
        .padding(10)
        .cornerRadius(10)
    }
}

struct MemosToolBarViewTest_Previews: PreviewProvider {
    static var previews: some View {
        MemosToolBarViewTest()
            .previewLayout(.sizeThatFits)
    }
}
