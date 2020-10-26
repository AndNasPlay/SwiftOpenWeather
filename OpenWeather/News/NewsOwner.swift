//
//  NewsOwner.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 25.10.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NewsSource {
    var title: String { get }
    var imageUrl: URL? { get }
}

struct NewsAllFeed {
    let friendsNews: [FriendNews]
    let groupNews: [GroupNews]
    let newsItems: [NewsItem]
}

struct AutorNews {
    let AutorFriend: FriendNews
    let AutroGroup: GroupNews
}

class FriendNews: NewsSource {
    let id: Int
    let firstName: String
    let lastName: String
    let avatarUrl: URL?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.lastName = json["last_name"].stringValue
        self.firstName = json["first_name"].stringValue
        let urlString = json["photo_100"].stringValue
        self.avatarUrl = URL(string: urlString)
    }
    
    // Protocol conformance
    var title: String { return "\(firstName) \(lastName)" }
    var imageUrl: URL? { return avatarUrl }
}

class GroupNews: NewsSource {
    let id: Int
    let name: String
    let avatarUrl: URL?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        let urlString = json["photo_200"].stringValue
        self.avatarUrl = URL(string: urlString)
    }
    
    // Protocol conformance
    var title: String { return name }
    var imageUrl: URL? { return avatarUrl }
}

