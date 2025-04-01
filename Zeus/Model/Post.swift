//
//  Post.swift
//  Zeus
//
//  Created by Renchi Liu on 3/29/25.
//

import Foundation

// MARK: - Configuration Constants

private enum MediaConfig {
    static let baseURL = BASEURL
    static let videoExtensions: Set<String> = ["mp4", "mov", "webm", "avi", "m4v"]
    static let imageExtensions: Set<String> = ["jpg", "jpeg", "png", "gif", "webp", "bmp", "tiff", "tif", "heif", "heic"]
}

// MARK: - Post

struct Post: Identifiable, Codable, Hashable {
    let rawID: String
    let user: String
    let service: String
    let title: String
    let content: String
    let published: String
    let file: PostFile?
    let attachments: [PostAttachment]?
    
    var id: String { "\(rawID)-\(published)" }
    
    var previewImageURL: URL? {
        if let path = file?.path, !path.isEmpty {
            return URL(string: MediaConfig.baseURL + path)
        }
        
        guard let attachments else { return nil }
        
        var fallbackVideoPath: String?
        
        for attachment in attachments {
            guard let path = attachment.path else { continue }
            let ext = (path as NSString).pathExtension.lowercased()
            
            if MediaConfig.imageExtensions.contains(ext) {
                return URL(string: MediaConfig.baseURL + path)
            } else if MediaConfig.videoExtensions.contains(ext), fallbackVideoPath == nil {
                fallbackVideoPath = path
            }
        }
        
        if let videoPath = fallbackVideoPath {
            return URL(string: MediaConfig.baseURL + videoPath)
        }
        
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case rawID = "id"
        case user, service, title, content, published, file, attachments
    }
}

// MARK: - PostFile

struct PostFile: Codable, Hashable {
    let name: String?
    let path: String?
}

// MARK: - PostAttachment

struct PostAttachment: Identifiable, Codable, Hashable {
    var id: String { path ?? UUID().uuidString }
    let name: String?
    let path: String?
    
    var imageURL: URL? {
        guard let path else { return nil }
        return URL(string: MediaConfig.baseURL + path)
    }
}
