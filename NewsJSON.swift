//
//  NewsJSON.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 26.09.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.

import Foundation

// MARK: - VkNews
class VkNews: Codable {
    let response: Response

    init(response: Response) {
        self.response = response
    }
}

// MARK: - Response
class Response: Codable {
    let items: [Item]
    let profiles: [Profile]
    let groups: [Group]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }

    init(items: [Item], profiles: [Profile], groups: [Group], nextFrom: String) {
        self.items = items
        self.profiles = profiles
        self.groups = groups
        self.nextFrom = nextFrom
    }
}

// MARK: - Group
class Group: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let isAdmin, isMember, isAdvertiser: Int
    let photo50, photo100, photo200: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }

    init(id: Int, name: String, screenName: String, isClosed: Int, type: String, isAdmin: Int, isMember: Int, isAdvertiser: Int, photo50: String, photo100: String, photo200: String) {
        self.id = id
        self.name = name
        self.screenName = screenName
        self.isClosed = isClosed
        self.type = type
        self.isAdmin = isAdmin
        self.isMember = isMember
        self.isAdvertiser = isAdvertiser
        self.photo50 = photo50
        self.photo100 = photo100
        self.photo200 = photo200
    }
}

// MARK: - Item
class Item: Codable {
    let sourceID, date: Int
    let canDoubtCategory, canSetCategory: Bool
    let postType, text: String
    let markedAsAds: Int
    let attachments: [Attachment]
    let postSource: PostSource
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
    let isFavorite: Bool
    let postID: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case postType = "post_type"
        case text
        case markedAsAds = "marked_as_ads"
        case attachments
        case postSource = "post_source"
        case comments, likes, reposts, views
        case isFavorite = "is_favorite"
        case postID = "post_id"
        case type
    }

    init(sourceID: Int, date: Int, canDoubtCategory: Bool, canSetCategory: Bool, postType: String, text: String, markedAsAds: Int, attachments: [Attachment], postSource: PostSource, comments: Comments, likes: Likes, reposts: Reposts, views: Views, isFavorite: Bool, postID: Int, type: String) {
        self.sourceID = sourceID
        self.date = date
        self.canDoubtCategory = canDoubtCategory
        self.canSetCategory = canSetCategory
        self.postType = postType
        self.text = text
        self.markedAsAds = markedAsAds
        self.attachments = attachments
        self.postSource = postSource
        self.comments = comments
        self.likes = likes
        self.reposts = reposts
        self.views = views
        self.isFavorite = isFavorite
        self.postID = postID
        self.type = type
    }
}

// MARK: - Attachment
class Attachment: Codable {
    let type: String
    let photo: Photo

    init(type: String, photo: Photo) {
        self.type = type
        self.photo = photo
    }
}

// MARK: - Photo
class Photo: Codable {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let accessKey: String
    let postID: Int
    let sizes: [Size]
    let text: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case postID = "post_id"
        case sizes, text
        case userID = "user_id"
    }

    init(albumID: Int, date: Int, id: Int, ownerID: Int, hasTags: Bool, accessKey: String, postID: Int, sizes: [Size], text: String, userID: Int) {
        self.albumID = albumID
        self.date = date
        self.id = id
        self.ownerID = ownerID
        self.hasTags = hasTags
        self.accessKey = accessKey
        self.postID = postID
        self.sizes = sizes
        self.text = text
        self.userID = userID
    }
}

// MARK: - Size
class Size: Codable {
    let height: Int
    let url: String
    let type: String
    let width: Int

    init(height: Int, url: String, type: String, width: Int) {
        self.height = height
        self.url = url
        self.type = type
        self.width = width
    }
}

// MARK: - Comments
class Comments: Codable {
    let count, canPost: Int

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
    }

    init(count: Int, canPost: Int) {
        self.count = count
        self.canPost = canPost
    }
}

// MARK: - Likes
class Likes: Codable {
    let count, userLikes, canLike, canPublish: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }

    init(count: Int, userLikes: Int, canLike: Int, canPublish: Int) {
        self.count = count
        self.userLikes = userLikes
        self.canLike = canLike
        self.canPublish = canPublish
    }
}

// MARK: - PostSource
class PostSource: Codable {
    let type: String

    init(type: String) {
        self.type = type
    }
}

// MARK: - Reposts
class Reposts: Codable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }

    init(count: Int, userReposted: Int) {
        self.count = count
        self.userReposted = userReposted
    }
}

// MARK: - Views
class Views: Codable {
    let count: Int

    init(count: Int) {
        self.count = count
    }
}

// MARK: - Profile
class Profile: Codable {
    let id: Int
    let firstName, lastName: String
    let isClosed, canAccessClosed: Bool
    let sex: Int
    let screenName: String
    let photo50, photo100: String
    let online: Int
    let onlineInfo: OnlineInfo

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case online
        case onlineInfo = "online_info"
    }

    init(id: Int, firstName: String, lastName: String, isClosed: Bool, canAccessClosed: Bool, sex: Int, screenName: String, photo50: String, photo100: String, online: Int, onlineInfo: OnlineInfo) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.isClosed = isClosed
        self.canAccessClosed = canAccessClosed
        self.sex = sex
        self.screenName = screenName
        self.photo50 = photo50
        self.photo100 = photo100
        self.online = online
        self.onlineInfo = onlineInfo
    }
}

// MARK: - OnlineInfo
class OnlineInfo: Codable {
    let visible, isOnline, isMobile: Bool

    enum CodingKeys: String, CodingKey {
        case visible
        case isOnline = "is_online"
        case isMobile = "is_mobile"
    }

    init(visible: Bool, isOnline: Bool, isMobile: Bool) {
        self.visible = visible
        self.isOnline = isOnline
        self.isMobile = isMobile
    }
}
