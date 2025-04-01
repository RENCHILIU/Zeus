//
//  SmartKFImage.swift
//  Zeus
//
//  Created by Renchi Liu on 3/31/25.
//

import SwiftUI
import Kingfisher


struct SmartKFImage<Placeholder: View>: View {
    let url: URL?
    let contentMode: SwiftUI.ContentMode
    let cornerRadius: CGFloat
    let width: CGFloat?
    let height: CGFloat?
    let placeholder: () -> Placeholder
    let useShimmer: Bool
    @Binding var isVideo: Bool
    
    @State private var shouldDisplayVideo: Bool = false
    init(
        url: URL?,
        contentMode: SwiftUI.ContentMode = .fill,
        cornerRadius: CGFloat = 8,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        useShimmer: Bool = true,
        @ViewBuilder placeholder: @escaping () -> Placeholder = {
            Rectangle().fill(Color.gray.opacity(0.3))
        },
        isVideo: Binding<Bool> = .constant(false)
    ) {
        self.url = url
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
        self.useShimmer = useShimmer
        self.placeholder = placeholder
        self._isVideo = isVideo
    }
    
    var body: some View {
        Group {
            if shouldDisplayVideo {
                videoPlaceholder
            } else {
                imageView
            }
        }
        .onAppear(perform: checkIfVideo)
       
    }
    
    
    private var imageView: some View {
        KFImage(url)
            .placeholder {
                if useShimmer {
                    placeholder().shimmering()
                } else {
                    placeholder()
                }
            }
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
    }
    
    private var videoPlaceholder: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            Image(systemName: "video.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundColor(.white.opacity(0.7))
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(cornerRadius)
    }
    
    private func checkIfVideo() {
        guard let ext = url?.pathExtension.lowercased() else { return }
        let videoExtensions = ["mp4", "mov", "webm", "avi", "m4v"]
        isVideo = videoExtensions.contains(ext)
        shouldDisplayVideo = videoExtensions.contains(ext)
    }
}
