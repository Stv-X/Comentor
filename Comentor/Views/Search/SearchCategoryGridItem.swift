//
//  SearchCategoryGridItem.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import CoreMotion

#if os(macOS)

#endif

struct SearchCategoryGridItem: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State var selection: SearchCategory
    
    @State private var pitch: CGFloat = 0.0
    @State private var roll: CGFloat = 0.0
    
#if os(iOS)
    let motionManager = CMMotionManager()
    let motionQueue = OperationQueue()
#endif
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                SearchCategoryDetail(selection: selection)
            }
        } label: {
            ZStack {
                LinearGradient(colors: [selection.color.complementaryColor, selection.color],
                               startPoint: colorScheme == .light ? .top : .bottom,
                               endPoint: colorScheme == .light ? .bottom : .top)
                
                Image(systemName: selection.image)
                    .foregroundColor(.black)
                    .font(.system(size: 50))
                    .imageScale(.large)
                    .scaleEffect(shadowScale)
                    .bold()
                    .opacity(0.14)
                    .blur(radius: shadowRadius)
                    .animation(.spring, value: pitch)
                
#if os(iOS)
                    .offset(x: roll * 20, y: pitch * 10)
                    .task {
                        enableMotionManager()
                    }
                    .onDisappear {
                        disableMotionManager()
                    }
#else
                    .offset(x: roll * 5, y: pitch * 5)
                    .task {
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                            updateCursorPosition()
                        }
                    }
#endif
                
                Image(systemName: selection.image)
                    .foregroundStyle(
                        LinearGradient(colors: [.black.opacity(0.5), .black],
                                       startPoint: .bottom,
                                       endPoint: .top)
                    )
                    .font(.system(size: 50))
                    .imageScale(.large)
                    .bold()
                    .opacity(0.3)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.ultraThickMaterial.opacity(0.8))
            }
            .frame(minHeight: 133)
        }
        .buttonStyle(SearchCategoryItemButtonStyle(title: selection.category.localizedLabel))
        .padding(.horizontal, 5)
    }
    
    struct SearchCategoryItemButtonStyle: ButtonStyle {
        @State var title: LocalizedStringKey
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                configuration.label
                    .overlay(.black.opacity(configuration.isPressed ? 0.2 : 0))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                VStack {
                    Spacer()
                    HStack {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(10)
                        Spacer()
                    }
                }
            }
        }
    }
    
#if os(macOS)
    private func updateCursorPosition() {
        if let window = NSApp.keyWindow {
            let mouseLocation = NSEvent.mouseLocation
            let viewLocation = window.convertPoint(fromScreen: mouseLocation)
            let displayFrame = NSScreen.main!.frame
            
            roll = -(viewLocation.x - displayFrame.midX) / 400
            pitch = (viewLocation.y - displayFrame.midY) / 300
        }
    }
#else
    private func enableMotionManager() {
        motionManager.startDeviceMotionUpdates(to: motionQueue) {
            data, error in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            let attitude: CMAttitude = data.attitude
            
            DispatchQueue.main.async {
                pitch = attitude.pitch
                roll = attitude.roll
            }
        }
    }
    private func disableMotionManager() {
        motionManager.stopDeviceMotionUpdates()
    }
#endif
    
    private var shadowScale: CGFloat {
#if os(iOS)
        let shadowOffset = CGPoint(
            x: roll * 20, y: pitch * 10
        )
#else
        let shadowOffset = CGPoint(
            x: roll * 5, y: pitch * 5
        )
#endif
        let offsetDistance = sqrt(shadowOffset.x * shadowOffset.x + shadowOffset.y * shadowOffset.y)
        return max(1, 1 + offsetDistance * 0.03)
        
    }
    
    private var shadowRadius: CGFloat {
#if os(iOS)
        let shadowOffset = CGPoint(
            x: roll * 20, y: pitch * 10
        )
#else
        let shadowOffset = CGPoint(
            x: roll * 5, y: pitch * 5
        )
#endif
        
        let offsetDistance = sqrt(shadowOffset.x * shadowOffset.x + shadowOffset.y * shadowOffset.y)
        
        return max(4, offsetDistance / 2)
    }
}
