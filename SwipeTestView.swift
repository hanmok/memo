//
//  TabButton.swift
//  CustomSwipePractice
//
//  Created by 이한목 on 2022/02/24.
//

import SwiftUI

struct CardView:  View {
    var item: Item
    var body: some View {
        Text(item.title)
    }
}

struct Item: Identifiable {
    var id = UUID().uuidString
    var title: String
    var price: String
    var offset: CGFloat = 0
}

var items = [
    Item(title: "Stylish Table Lamp", price: "$20.00"),
    Item(title: "Stylish Table Lamp", price: "$20.00"),
    Item(title: "Stylish Table Lamp", price: "$20.00")
]

struct MainView: View {
    
    @GestureState var isDragging = false
    
//    let items = ["hello", "guys"]
    @State var cart: [Item] = []

    var body: some View {
        VStack {
            HStack { EmptyView()}
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 10)
            
            ScrollView {
                
                VStack {
                    
                    
                    ForEach(items.indices) { index in
                        
                        ZStack {
                            Color("tab")
                                .cornerRadius(20)
                            
                            Color("Color")
                                .cornerRadius(20)
                                .padding(.trailing, 65)
                            
                            // Button...
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "suit.heart")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 65)
                                }
                                
                                Button(action: {
                                    addCart(index: index)
                                }) {
                                    
                                    Image(systemName: "cart.badge.plus")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 65)
                                }
                            }
                            
                            CardView(item: items[index])
                                .offset(x: items[index].offset)
                                .gesture(DragGesture()
                                            .updating($isDragging, body: { value, state, _ in
                                    state = true
                                    onChanged(value: value, index: index)
                                }).onEnded({ value in
                                    onEnd(value: value, index: index)
                                }))
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }
    
    func checkCart(index: Int) -> Bool {
        return cart.contains { (item) -> Bool in
            return item.id == items[index].id
        }
    }
    
    func addCart(index: Int) {
        if checkCart(index: index) {
            cart.removeAll { (item) -> Bool in
                return item.id == items[index].id
            }
        } else {
            cart.append(items[index])
        }
        
        // closing after added ..
        withAnimation {
            items[index].offset = 0
        }

    }
    
    func onChanged(value: DragGesture.Value, index: Int) {
        if value.translation.width < 0 && isDragging {
            items[index].offset = value.translation.width
        }
    }
    
    func onEnd(value: DragGesture.Value, index: Int) {
        withAnimation {
            if -value.translation.width >= 100 {
                items[index].offset = -130
            }
            else {
                items[index].offset = 0
            }
        }
    }
}

