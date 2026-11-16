//
//  ProductData.swift
//  GasMan
//
//  Created by Haneen on 07/03/2026.
//

struct ProductDetailsResponse: Codable {
    let id: Int?
    let fullTitle: String?
    let title: String?
    let description: String?
    let image: String?
    let price: String?
    let currency: String?
    let category: Categories?
    let type: ProductType?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullTitle = "full_title"
        case title
        case description
        case image
        case price
        case currency
        case category
        case type
    }
}
