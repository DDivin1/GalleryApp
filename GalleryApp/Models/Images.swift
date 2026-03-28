//
//  Images.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation

struct Images: Codable, Identifiable {
    let id: String
    let description: String?
    let altDescription: String?
    let likes: Int?
    let createdAt: String?
    let urls: ImagesURLs
    let user: User?
    
    var displayDescription: String {
        description ?? altDescription ?? "No description"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case altDescription = "alt_description"
        case likes
        case createdAt = "created_at"
        case urls
        case user
    }
}

struct ImagesURLs: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    
    var thumbURL: String? {thumb ?? small ?? regular}
    var regularURL: String? {regular ?? full}
}

struct User: Codable {
    let name: String?
    let username: String?
    
    var displayName: String {
        name ?? username ?? "Unknown"
    }
}


