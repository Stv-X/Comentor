//
//  SearchCategoryGridItem.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import CoreMotion

#if os(macOS)

#endif

struct SearchCategoryGridItem: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State var category: SearchCategory
    
    @State private var pitch: CGFloat = 0.0
    @State private var roll: CGFloat = 0.0
    
    #if os(iOS)
    let motionManager = CMMotionManager()
    let motionQueue = OperationQueue()
    #endif
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                SearchCategoryDetail(selection: category)
            }
        } label: {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(colors: [category.color.complementaryColor, category.color],
                                   startPoint: colorScheme == .light ? .top : .bottom,
                                   endPoint: colorScheme == .light ? .bottom : .top)
                    
                    Image(systemName: category.image)
                        .foregroundColor(.black)
                        .font(.system(size: 80))
                        .imageScale(.large)
                        .bold()
                        .opacity(0.14)
                        .blur(radius: shadowRadius(innerGeometry: geometry))
                        .animation(.spring, value: pitch)
                    
#if os(iOS)
                        .offset(x: 40 + roll * 20, y: 20 + pitch * 10)

                        .task {
                            enableMotionManager()
                        }
                        .onDisappear {
                            disableMotionManager()
                        }
#else
                        .offset(x: 20 + roll * 5, y: pitch * 5)
#endif
                    
                    Image(systemName: category.image)
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
#if os(macOS)
                .overlay(GeometryReader { innerGeometry in
                    Color.clear
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                updateCursorPosition(innerGeometry: innerGeometry)
                            }
                        }
                })
#endif
            }
            .frame(minHeight: 133)
        }
        .buttonStyle(SearchCategoryItemButtonStyle(title: category.category.rawValue.capitalized))
        .padding(.horizontal, 5)
    }
    
    struct SearchCategoryItemButtonStyle: ButtonStyle {
        @State var title: String
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                configuration.label
                    .overlay(.black.opacity(configuration.isPressed ? 0.2 : 0))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                VStack {
                    Spacer()
                    HStack {
                        Text(LocalizedStringKey(title))
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
    private func updateCursorPosition(innerGeometry: GeometryProxy) {
        if let window = NSApp.keyWindow {
            let mouseLocation = NSEvent.mouseLocation
            let viewLocation = window.convertPoint(fromScreen: mouseLocation)
            let viewFrame = innerGeometry.frame(in: .local)
            
            roll = -(viewLocation.x - viewFrame.midX) / 400
            pitch = (viewLocation.y - viewFrame.midY) / 300
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
    
    private func shadowRadius(innerGeometry: GeometryProxy) -> CGFloat {
        let viewFrame = innerGeometry.frame(in: .local)
        
        let centerPoint = CGPoint(x: viewFrame.midX, y: viewFrame.midY)
        
        let shadowOffset = CGPoint(
            x: 40 + roll * 20, y: 20 + pitch * 10
        )
        
        let distanceX = centerPoint.x.distance(to: shadowOffset.x)
        let distanceY = centerPoint.y.distance(to: shadowOffset.y)
        
        let distance = sqrt(distanceX * distanceX + distanceY * distanceY)
        
        return max(4, distance / 10)
    }
}
