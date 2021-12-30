//
//  MainTabView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

//struct MainTabView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}

//struct MainTabView : View {
//
//    let numOfTabs : CGFloat = 5.0
//    let imageInset : CGFloat = 40.0
//    let initialPadding : CGFloat = 20
////    let sizeRatioForTab : CGFloat = 1.0 / 5.0
////    let width = self.width
//
//    var body: some View {
//        GeometryReader { metrics in
//
//                HStack(spacing:0) {
//
//                    Button(action: {}) {
//                        VStack {
//                            Image(systemName: "person.fill")
//                                .resizable()
//                                .frame(width: metrics.size.width / numOfTabs - imageInset, height: metrics.size.width / numOfTabs - imageInset, alignment: .center)
//                                .aspectRatio( contentMode: .fit)
////                            Text("My")
//                                .font(.caption)
//                        }
//                    }
//                    .frame(width: metrics.size.width / numOfTabs, height: metrics.size.width / numOfTabs + 20, alignment: .center)
////                    .frame(width: metrics.size.width * sizeRatioForTab, height: 40)
////                        .background(.green)
//
//                    Button(action: {}) {
//                        VStack {
//                            Image(systemName: "globe")
//                                .resizable()
//                                .frame(width: metrics.size.width / numOfTabs - imageInset, height: metrics.size.width / numOfTabs - imageInset, alignment: .center)
//                                .aspectRatio( contentMode: .fit)
////                            Text("Surfing")
//                                .font(.caption)
//                        }
//                    }
//                    .frame(width: metrics.size.width / numOfTabs, height: metrics.size.width / numOfTabs + 20, alignment: .center)
//
//
//                    Button(action: {}) {
//                        VStack {
//                            Image(systemName: "waveform.path.ecg")
//                                .resizable()
//                                .frame(width: metrics.size.width / numOfTabs - imageInset, height: metrics.size.width / numOfTabs - imageInset, alignment: .center)
//                                .aspectRatio( contentMode: .fit)
////                            Text("Graphs")
//                                .font(.caption)
//                        }
//                    }
//                    .frame(width: metrics.size.width / numOfTabs, height: metrics.size.width / numOfTabs + 20, alignment: .center)
//
//
//                    Button(action: {}) {
//                        VStack {
//                            Image(systemName: "bubble.left.and.bubble.right.fill")
//                                .resizable()
//                                .frame(width: metrics.size.width / numOfTabs - imageInset, height: metrics.size.width / numOfTabs - imageInset, alignment: .center)
//                                .aspectRatio( contentMode: .fit)
////                            Text("community")
//                                .font(.caption)
//                        }
//                    }
//                    .frame(width: metrics.size.width / numOfTabs, height: metrics.size.width / numOfTabs + 20, alignment: .center)
//
//                    Button(action: {}) {
//                        VStack {
//                            Image(systemName: "person.3.fill")
//                                .resizable()
//                                .frame(width: metrics.size.width / numOfTabs - imageInset, height: metrics.size.width / numOfTabs - imageInset, alignment: .center)
//                                .aspectRatio( contentMode: .fit)
////                            Text("Friends'")
//                                .font(.caption)
//                        }
//                    }
//                    .frame(width: metrics.size.width / numOfTabs, height: metrics.size.width / numOfTabs + 20, alignment: .center)
//                }
//                .tint(.black)
////                .padding(.horizontal, initialPadding)
//        }
//    }
//}


struct MainTabView: View {
    var body: some View {
        EmptyView()
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
//            .frame( height: 35, alignment: .center)
//            .frame(width: .infinity, height: 45, alignment: .center)
            .previewLayout(.sizeThatFits)
    }
}
