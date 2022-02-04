//
//  TestLazyAndScrollView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct TestLazyAndScrollView: View {
    var body: some View {
        VStack {
        ScrollView {
            LazyVStack {
                Text("hi")
            }
//            .background(.green)
            Spacer()
        }

        Spacer()
        }
    }
}

struct TestLazyAndScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TestLazyAndScrollView()
    }
}


// 문제가.. ScrollView 에 있는 것 같아
