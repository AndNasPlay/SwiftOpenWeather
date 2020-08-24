//
//  GroupsJSON.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 19.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation

class GroupsInfo: Decodable {
    let response: GroupsResponse
}
class GroupsResponse: Decodable {
    var count: Int = 0
    var items: [GroupsItems]
}
class GroupsItems: Decodable {
    var id: Int = 0
    var name: String = ""
    
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
}
