//
//  UIExtensions.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import SwiftUI

extension Color {
    var complementaryColor: Color {
        switch self {
        case .red:
            return .pink
        case .blue:
            return .cyan
        case .orange:
            return .yellow
        case .pink:
            return .purple
        case .purple:
            return .indigo
        case .mint:
            return .teal
        case .teal:
            return .cyan
        case .green:
            return .mint
        case .gray:
#if os(iOS)
            return Color(uiColor: UIColor.systemGray3)
#else
            return Color(nsColor: systemGray3())
#endif
        case .indigo:
            return .blue
        default:
            return .white
        }
    }
}

#if os(macOS)

func systemGray3() -> NSColor {
    if #available(OSX 10.14, *) {
        let appearance = NSApp.effectiveAppearance
        if appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
            return NSColor(red: 72/255, green: 72/255, blue: 74/255, alpha: 1.0)
        } else {
            return NSColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1.0)
        }
    } else {
        return NSColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1.0)
    }
}

#endif
