//
//  PhotoJSON.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 28.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation

class PhotoInfo: Codable {
    var response: PhotoResponse
}

class PhotoResponse: Codable {
    var count: Int
    var items: [PhotoItems]
}

class PhotoItems: Codable {
    var id: Int = 0
    var ownerId: Int = 0
    var sizes: [String: String] = [:]
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sizes
    }
    enum PhotoKeys: String, CodingKey {
        case height, type, url, width
    }
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)
        
        var photoValues = try values.nestedUnkeyedContainer(forKey: .sizes)
        while !photoValues.isAtEnd {
            let photo = try photoValues.nestedContainer(keyedBy: PhotoKeys.self)
            let photoType = try photo.decode(String.self, forKey: .type)
            let photoUrl = try photo.decode(String.self, forKey: .url)
            sizes[photoType] = photoUrl
        }
    }
}

