
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

