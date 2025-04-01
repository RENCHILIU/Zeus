//
//  FullScreenImageView.swift
//  Zeus
//
//  Created by Renchi Liu on 3/29/25.
//

//TODO: changing dismiss style
import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    @Binding var url: URL?
    
    @State private var scale: CGFloat = 1.0
    @State private var baseScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var baseOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let imageURL = url {
                SmartKFImage(url: imageURL, contentMode: .fit)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(combinedGestures)
                .onTapGesture(count: 2, perform: handleDoubleTap)
                .onTapGesture(count: 1, perform: dismiss)
                .id(imageURL)
            }
        }
    }
    
    private var combinedGestures: some Gesture {
        SimultaneousGesture(
            MagnificationGesture()
                .onChanged { value in
                    scale = baseScale * value
                }
                .onEnded { _ in
                    baseScale = scale
                    if scale < 1.0 {
                        resetView()
                    }
                },
            DragGesture()
                .onChanged { value in
                    if scale > 1.0 {
                        offset = CGSize(
                            width: baseOffset.width + value.translation.width,
                            height: baseOffset.height + value.translation.height
                        )
                    }
                }
                .onEnded { _ in
                    baseOffset = offset
                }
        )
    }
    
    private func handleDoubleTap() {
        withAnimation(.spring()) {
            if scale > 1.0 {
                resetView()
            } else {
                scale = 2.5
                baseScale = 2.5
            }
        }
    }
    
    private func resetView() {
        withAnimation {
            scale = 1.0
            baseScale = 1.0
            offset = .zero
            baseOffset = .zero
        }
    }
    
    private func dismiss() {
        url = nil
    }
}
