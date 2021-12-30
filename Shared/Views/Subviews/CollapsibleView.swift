//
//  CollapsibleView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct CollapsibleView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

import SwiftUI

struct Collapsible<Content: View>: View {
    @State var label: String
    @State var content: () -> Content
    
    @State private var collapsed: Bool = true
    
    var body: some View {
        //        GeometryReader { myproxy in
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Button(
                    action: { self.collapsed.toggle() },
                    label: {
                        HStack {
                            Text(self.label)
                            Spacer()
                            Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                        }
                        .padding(.bottom, 1)
                        .background(Color.white.opacity(0.01))
                    }
                )
                    .buttonStyle(PlainButtonStyle())
                
                self.content()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
                    .clipped()
                    .animation(.easeOut, value: collapsed)
                    .transition(.slide)
                Spacer()
            }
            .background(.green)
            //    }
        }
    }
}

struct TestView: View {
    var body: some View {
        Collapsible(label: "Hi") {
            ScrollView {
                LazyVStack {
                    VStack {
                        Text("Testing1")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing11")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing21")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing31")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                    VStack {
                        Text("Testing41")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                        Text("Testing")
                    }
                }}
        }
    }
}

struct CollapsibleView_Previews: PreviewProvider {
    static var previews: some View {
        CollapsibleView()
    }
}
