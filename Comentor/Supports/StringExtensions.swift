//
//  StringExtensions.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import Foundation

#if os(iOS)
import UIKit
#else
import AppKit
#endif


extension String {
    func twoLevelDomain() -> String? {
        let components = self.components(separatedBy: ".")
        if components.count > 2 {
            return components[components.count - 2] + "." + components[components.count - 1]
        }
        return nil
    }
}

extension String {
    func copyToClipBoard() {
#if os(macOS)
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(self, forType: .string)
#elseif os(iOS)
        UIPasteboard.general.string = self
#endif
    }
}

