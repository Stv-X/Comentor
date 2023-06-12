//
//  Navigation.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI

struct NavigationItem: Identifiable, CaseIterable, Hashable, Equatable {
    static var allCases: [NavigationItem] = navigationItems
    
    let id = UUID()
    let title: String
    let image: String
    
    var destination: some View {
        switch self {
        case navigationItems[0]:
            return AnyView(StudyNowView())
        case navigationItems[1]:
            return AnyView(ChatView())
        case navigationItems[2]:
            return AnyView(SearchView())
        default:
            return AnyView(WelcomeView())
        }
    }
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}

let navigationItems = [
    NavigationItem(title: "Study Now", image: "graduationcap"),
    NavigationItem(title: "Chat", image: "text.bubble.left.and.bubble.right"),
    NavigationItem(title: "Search", image: "magnifyingglass")
]
