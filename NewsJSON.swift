//
//  NewsJSON.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 26.09.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - NewsInfo
class NewsInfo: Codable {
    var response: ResponseNews
}

// MARK: - Response
class ResponseNews: Codable {
    var items: [Item]
    var profiles: [Profile]
    var groups: [Group]
    var nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

// MARK: - Group
class Group: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var photo50: String = ""
    @objc dynamic var photo100: String = ""
    @objc dynamic var photo200: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case type
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.screenName = try values.decode(String.self, forKey: .screenName)
        self.type = try values.decode(String.self, forKey: .type)
        self.photo50 = try values.decode(String.self, forKey: .photo50)
        self.photo100 = try values.decode(String.self, forKey: .photo100)
        self.photo200 = try values.decode(String.self, forKey: .photo200)
    }
}

// MARK: - Item
class Item: Object, Codable {
    @objc dynamic var sourceID: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var postType: String = ""
    @objc dynamic var text: String = ""
    let attachments = List<Attachment>()
    let comments = List<Comments>()
    let likes = List<Likes>()
    let views = List<Views>()
    @objc dynamic var isFavorite: Bool = true
    @objc dynamic var postID: Int = 0
    @objc dynamic var type: String = ""
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case postType = "post_type"
        case text
        case attachments
        case comments, likes, views
        case isFavorite = "is_favorite"
        case postID = "post_id"
        case type
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceID = try values.decode(Int.self, forKey: .sourceID)
        self.date = try values.decode(Int.self, forKey: .date)
        self.postType = try values.decode(String.self, forKey: .postType)
        self.text = try values.decode(String.self, forKey: .text)
//        self.attachments = try values.decode(List<Attachment>.self, forKey: .attachments)
//        self.comments = try values.decode(List<Comments>.self, forKey: .comments)
//        self.likes = try values.decode(List<Likes>.self, forKey: .likes)
//        self.views = try values.decode(List<Views>.self, forKey: .views)
        self.isFavorite = try values.decode(Bool.self, forKey: .isFavorite)
        self.postID = try values.decode(Int.self, forKey: .postID)
        self.type = try values.decode(String.self, forKey: .type)
    }
    
}

// MARK: - Attachment
class Attachment: Object, Codable {
    @objc dynamic var type: String = ""
    let photo = List<Photo>()
    
    enum CodingKeys: String, CodingKey {
        case type
        case photo
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try values.decode(String.self, forKey: .type)
        //self.photo = try values.decode([Photo].self, forKey: .photo)
    }
}

// MARK: - Photo
class Photo: Object, Codable {
    @objc dynamic var albumID: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    @objc dynamic var accessKey: String = ""
    @objc dynamic var postID: Int = 0
    let sizes = List<Size>()
    @objc dynamic var text: String = ""
    @objc dynamic var userID: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case accessKey = "access_key"
        case postID = "post_id"
        case sizes, text
        case userID = "user_id"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.albumID = try values.decode(Int.self, forKey: .albumID)
        self.date = try values.decode(Int.self, forKey: .date)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerID = try values.decode(Int.self, forKey: .ownerID)
        self.accessKey = try values.decode(String.self, forKey: .accessKey)
        self.postID = try values.decode(Int.self, forKey: .postID)
        //self.sizes = try values.decode([Size].self, forKey: .sizes)
        self.text = try values.decode(String.self, forKey: .text)
        self.userID = try values.decode(Int.self, forKey: .userID)
    }
}

// MARK: - Size
class Size: Object, Codable {
    @objc dynamic var height: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var width: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case height
        case url
        case type
        case width
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.height = try values.decode(Int.self, forKey: .height)
        self.url = try values.decode(String.self, forKey: .url)
        self.type = try values.decode(String.self, forKey: .type)
        self.width = try values.decode(Int.self, forKey: .width)
    }
}

// MARK: - Comments
class Comments: Object, Codable {
    @objc dynamic var count: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case count
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try values.decode(Int.self, forKey: .count)
    }
    
}

// MARK: - Likes
class Likes: Object, Codable {
    @objc dynamic var count: Int = 0
    @objc dynamic var userLikes: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try values.decode(Int.self, forKey: .count)
        self.userLikes = try values.decode(Int.self, forKey: .userLikes)
    }
}

// MARK: - Views
class Views: Object, Codable {
    @objc dynamic var count: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case count
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try values.decode(Int.self, forKey: .count)
    }
}

// MARK: - Profile
class Profile: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var sex: Int = 0
    @objc dynamic var screenName: String = ""
    @objc dynamic var photo50: String = ""
    @objc dynamic var photo100: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.sex = try values.decode(Int.self, forKey: .sex)
        self.screenName = try values.decode(String.self, forKey: .screenName)
        self.photo50 = try values.decode(String.self, forKey: .photo50)
        self.photo100 = try values.decode(String.self, forKey: .photo100)
    }
    
}
