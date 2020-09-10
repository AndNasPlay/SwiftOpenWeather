//
//  GroupsJSON.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 19.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation
import RealmSwift

class GroupsInfo: Codable {
    let response: GroupsResponse
}
class GroupsResponse: Codable {
    var count: Int = 0
    var items: [GroupsItems]
}
class GroupsItems: Object, Codable {
     @objc dynamic var id: Int = 0
     @objc dynamic var name: String = ""
     @objc dynamic var type: String = ""
     @objc dynamic var groupImg: String = ""
     @objc dynamic var ageLimits: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case groupImg = "photo_100"
    }
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.type = try values.decode(String.self, forKey: .type)
        self.groupImg = try values.decode(String.self, forKey: .groupImg)
    }
    override class func primaryKey() -> String? {
        return "id"
    }
}
