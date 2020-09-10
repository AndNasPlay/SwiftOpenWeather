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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
    }
//    override class func primaryKey() -> String? {
//        return "id"
//    }
}
