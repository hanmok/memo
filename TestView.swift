//
//  TestView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        List {
            ForEach(1 ..< 18) { index in
                Text("\(index)")
                // from the leading side.
//                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                        Button(action: {
//                            print("hi")
//                        }) {
//                            Text("hello")
//                        }
//                    }
            }
        }
        Spacer()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
