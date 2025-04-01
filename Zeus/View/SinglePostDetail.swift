//
//  SinglePostDetail.swift
//  Zeus
//
//  Created by Renchi Liu on 3/30/25.
//

import SwiftUI
import Kingfisher

struct SinglePostDetail: View {
    let post: Post
    @State private var showSafari: Bool = false
    @State private var isVideo: Bool = false
    
    @Binding var selectedImageURL: URL?
    
    private struct Constants {
        static let placeholderColor = Color.gray.opacity(0.1)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let previewURL = post.previewImageURL {
                    previewImageView(previewURL)
                }
                
                if !post.content.isEmpty {
                    HTMLTextView(htmlContent: post.content)
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)

                }
                
                if let attachments = post.attachments, !attachments.isEmpty {
                    Text("Attachments")
                        .font(.headline)
                    
                    ForEach(attachments, id: \.id) { attachment in
                        if let imageURL = attachment.imageURL {
                            previewImageView(imageURL)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func previewImageView(_ url: URL) -> some View {
        SmartKFImage(
            url: url,
            contentMode: .fit,
            width: UIScreen.main.bounds.width - 32,
            isVideo: $isVideo
        )
            .onTapGesture {
                if isVideo {
                    showSafari = true
                } else {
                    selectedImageURL = url
                }
            }
            .sheet(isPresented: $showSafari) {
                SafariView(url: url)
            }
            .id(url)
    }
}

