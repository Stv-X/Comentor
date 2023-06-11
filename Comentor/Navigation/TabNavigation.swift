//
//  TabNavigation.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI

struct TabNavigation: View {
    
    var body: some View {
        TabView {
            ForEach(NavigationItem.allCases) { selection in
                NavigationStack {
                    selection.destination
                        .navigationTitle(selection.title)
                }
                .tabItem {
                    Label(LocalizedStringKey(selection.title), systemImage: selection.image)
                        .onLongPressGesture {
                            print("\(selection.title) is Tapped")
                        }
                }
            }
        }
    }
}
