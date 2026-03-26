//
//  Images.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation

enum CodingKeys: String, CodingKey {
    case id, urls, user, description, likes
    case altDescription = "alt_description"
    case createdAt = "created_at"
}
enum UserCodingKeys: String, CodingKey {
    case id, name, username
    case profileImage = "profile_image"
}

struct Images: Codable {
    let id: String
    let urls: PhotoURLs
    let user: User
    let description: String?
    let altDescription: String?
    let likes: Int
    let createdAt: String
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Codable {
    let id: String
    let name: String
    let username: String
    let profileImage: ProfileImage?
}

struct ProfileImage: Codable {
    let medium: String
    let small: String
    let large: String
}

