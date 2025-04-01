//
//  ShimmerEffect.swift
//  Zeus
//
//  Created by Renchi Liu on 3/29/25.
//

import SwiftUI

// Customized animation as Shimmer is better than gif
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = -1.0
    
    var background: Color
    var highlight: Color
    var angle: Angle = .degrees(30)
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let size = geometry.size
                    let shimmerWidth = size.width * 2.5
                    
                    LinearGradient(
                        gradient: Gradient(colors: [background, highlight, background]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: shimmerWidth, height: size.height)
                    .rotationEffect(angle)
                    .offset(x: phase * shimmerWidth)
                    .onAppear {
                        withAnimation(
                            .linear(duration: 1.5)
                            .repeatForever(autoreverses: false)
                        ) {
                            phase = 1.0
                        }
                    }
                }
                    .mask(alignment: .center) {
                        content
                    }
            )
    }
}

extension View {
    func shimmering(
        background: Color = Color.gray.opacity(0.3),
        highlight: Color = Color.white.opacity(0.6),
        angle: Angle = .degrees(30)
    ) -> some View {
        self.modifier(
            ShimmerEffect(
                background: background,
                highlight: highlight,
                angle: angle
            )
        )
    }
}
