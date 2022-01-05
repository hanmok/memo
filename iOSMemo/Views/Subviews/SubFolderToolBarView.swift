//
//  SubFolderToolBarView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/28.
//

import SwiftUI

struct SubFolderToolBarView: View {
    var body: some View {
        GeometryReader { proxy in
            HStack {
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "folder.badge.plus", width: 20, height: 20)
                }
                .padding(.leading, Sizes.largePadding)
                Spacer()
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "pencil", width: 20, height: 20)
                }
                Spacer()
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "arrow.up.and.down", width: 20, height: 20)
                }
                Spacer()
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "doc.on.doc", width: 20, height: 20)
                }
                Spacer()
                Button(action: {}) {
                    ChangeableImage(imageSystemName: "trash", width: 20, height: 20)
                }
                
                .padding(.trailing, Sizes.largePadding)
            }
            .padding(.vertical, 5)
            .frame(height: 40)
        }
        .frame(height: 40)
        .background(.yellow)
    }
}

struct SubFolderToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            SubFolderToolBarView()
                .previewLayout(.sizeThatFits)
            Spacer()
        }
    }
}


//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(Roundedcorner(radius: radius, corners: corners))
//    }
//}

//extension View {
//    func cornerRadius2(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//
//
//    }
//}

//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//
//}
