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
            
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "pin",width: 20, height: 20)
                }
//                .padding(5)
                .padding([.leading], 25)
                .padding([.vertical, .trailing], 5)
                
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
//                .padding(5)
                .padding(.trailing, 25)
                .padding([.leading, .vertical], 5)
                .cornerRadius(5)
        }
//        .padding([.leading, .trailing], 30)
        .frame(width: 170, height: 30, alignment: .center)
        .padding(5)
        .background(.green)
        .cornerRadius(10)

        
//        .cornerRadius(15)

//        .background(.green)
        
    }
}

struct MemosToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        MemosToolBarView()
            .previewLayout(.sizeThatFits)
    }
}
