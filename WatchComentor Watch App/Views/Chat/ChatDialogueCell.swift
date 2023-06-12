//
//  ChatDialogueCell.swift
//  WatchComentor Watch App
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import SwiftUI

struct ChatDialogueCell: View {
    var dialogue: Dialogue
    
    @State var isRequestingAnswer: Bool
    
    @AppStorage("CurrentMessage") private var currentReceivedMessage = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Me")
                .font(.footnote)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            Text(dialogue.ask)
                .font(.footnote)
            
            Divider()
            
            Text("Comentor")
                .font(.footnote)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            if isRequestingAnswer && dialogue.answer == "" && currentReceivedMessage == "" {
                ProgressView()
            } else if isRequestingAnswer && dialogue.answer == "" && currentReceivedMessage != "" {
                Text(currentReceivedMessage)
                    .font(.footnote)
            } else {
                if dialogue.answer != "" && dialogue.success {
                    Text(dialogue.answer)
                        .font(.footnote)
                }
            }
            Divider()
        }
    }
}
