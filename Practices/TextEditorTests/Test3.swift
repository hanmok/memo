////
////  ContentView.swift
////  TextEditorTests
////
////  Created by Mac mini on 2022/02/16.
////
//
//import SwiftUI
//
//struct ContentView3: View {
//    @State private var textEditorHeight : CGFloat = 100
//    @State private var text = "Testing text. Hit a few returns to see what happens"
//
//    var body: some View {
//        ScrollView {
//
//            VStack{
//                Text("This is my Title !!!!!!!!!!!!")
//                Text("This should be above")
//                ZStack(alignment: .leading) {
//                    Text(text)
////                        .font(.custom("Courier", size: 24))
//                        .foregroundColor(.clear)
//                        .padding(14)
////                        .background(GeometryReader {
////                            Color.clear.preference(key: ViewHeightKey.self,
////                                                   value: $0.frame(in: .local).size.height)
////                        })
//                        .fixedSize(horizontal: false, vertical: true)
//                    TextEditor(text: $text)
////                        .font(.custom("Courier", size: 24))
//                        .padding(6)
//                        .frame(height: textEditorHeight)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .background(Color.black)
//                }
//                .padding(20)
//                .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
//
//                Text("This should be below the text field")
//                Spacer()
//            }
//
//        }
//
//    }
//}
