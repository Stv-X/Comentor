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
    init(title: LocalizedStringResource, image: String) {
        self.title = String(localized: title)
        self.image = image
    }
}

let navigationItems = [
    NavigationItem(title: "Study Now", image: "graduationcap"),
    NavigationItem(title: "Chat", image: "bubble.left.and.text.bubble.right"),
    NavigationItem(title: "Search", image: "magnifyingglass")
]
