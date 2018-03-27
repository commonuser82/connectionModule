//
//  ModelClass.swift
//  ConnectionModule
//
//  Created by SYS005 on 12/26/17.
//  Copyright © 2017 SYS005. All rights reserved.
//

import UIKit

struct ModelClass: Decodable
{
 let data: [AnimeDataArray]
}
struct AnimeDataArray: Codable {
    let countries_name: String?
    let id: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case countries_name = "countries_name"
        
    }
}

