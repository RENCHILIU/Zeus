//
//  GridRowView.swift
//  Zeus
//
//  Created by Renchi Liu on 3/30/25.
//

import SwiftUI
import Kingfisher

struct GridRowView: View {
    let row: [Post]
    let gridWidth: CGFloat
    let spacing: CGFloat
    let onAppear: () -> Void
    let onSelect: (Post) -> Void
    
    private struct Constants {
        static let cornerRadius: CGFloat = 8
        static let titleFont: Font = .subheadline
        static let dateFont: Font = .caption
        static let dateColor: Color = .gray
        static let verticalSpacing: CGFloat = 4
        static let placeholderColor = Color.gray.opacity(0.1)
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(row, id: \.id) { post in
                VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                    if let url = post.previewImageURL {
                        SmartKFImage(
                            url: url,
                            width: gridWidth,
                            height: gridWidth
                        )
                        .clipped()
                        .cornerRadius(Constants.cornerRadius)
                    }
                    
                    Text(postTitle(for: post))
                        .font(Constants.titleFont)
                        .lineLimit(1)
                    
                    Text(post.published)
                        .font(Constants.dateFont)
                        .foregroundColor(Constants.dateColor)
                }
                .frame(width: gridWidth)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelect(post)
                }
                .id(post.id)
            }
            
            if row.count < GridStyle.columns {
                Spacer(minLength: gridWidth + spacing)
            }
        }
        .padding(.horizontal)
        .onAppear(perform: onAppear)
    }
    
    private func postTitle(for post: Post) -> String {
        if !post.title.isEmpty {
            return post.title
        } else if !post.content.isEmpty {
            return post.content
        } else {
            return "No Title"
        }
    }
}
