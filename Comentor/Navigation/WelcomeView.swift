//
//  WelcomeView.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("Comentor_Icon_Dark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
                .opacity(0.7)
            Text("Welcome to Comentor")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .bold()
                .fontWidth(.compressed)
        }
    }
}
