//
//  RoadmapGenerationStatusToast.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/11.
//

import SwiftUI

enum GenerationStatus {
    case succeed, failed, inProgress
}

struct RoadmapGenerationStatusToast: View {
    @State var status: GenerationStatus
    @State var title: String
    
    var body: some View {
        VStack {
            if status == .inProgress {
                ProgressView()
                    .progressViewStyle(.circular)
#if os(iOS)
                    .scaleEffect(1.8)
#endif
                    .frame(width: 50, height: 50)
                    .padding(.bottom, 5)
                
            } else {
                Image(systemName: symbol)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .bold()
                    .padding(.bottom, 5)
            }
            if status == .succeed {
                Text(title)
                    .bold()
            }
            Text(message)
        }
        .opacity(0.4)
        .padding(30)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    private var symbol: String {
        switch status {
        case .succeed:
            return "checkmark"
        case .failed:
            return "xmark"
        case .inProgress:
            return "ellipsis"
        }
    }
    private var message: LocalizedStringKey {
        switch status {
        case .succeed:
            return "Generation Succeed"
        case .failed:
            return "Generation Failed"
        case .inProgress:
            return "Generating..."
        }
    }
}

