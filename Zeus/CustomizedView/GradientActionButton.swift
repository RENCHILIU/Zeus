//
//  GradientActionButton.swift
//  Zeus
//
//  Created by Renchi Liu on 3/31/25.
//

import SwiftUI

struct GradientActionButton: View {
    let title: String
    let gradient: [Color]
    let isDisabled: Bool
    let action: () -> Void
    
    @Binding var isPressed: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPressed = false
                action()
            }
        }) {
            Text(title)
                .fontWeight(.medium)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: gradient, startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .disabled(isDisabled)
    }
}
