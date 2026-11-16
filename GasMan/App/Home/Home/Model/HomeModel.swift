//
//  HomeModel.swift
//  Esterad
//
//  Created by Haneen on 11/11/2025.
//

import Foundation


// MARK: - HomeResponse -

struct HomeResponse: Codable {
    let city: AreaModel?
    let sliders: [Slider]?
    let categoriesWithProducts: [Categories]?
      
      enum CodingKeys: String, CodingKey {
          case city
          case sliders
          case categoriesWithProducts = "categories_with_products"
      }
  }

// MARK: - Slider -

struct Slider: Codable {
    let id: Int?
    let image: String?
}

// MARK: - Category -

struct Categories: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let products: [Products]?
}

// MARK: - Product -

struct Products: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let image: String?
    let price: String?
    let currency: String?
    let type: ProductType?
}

// MARK: - Product Type -

struct ProductType: Codable {
    let key: Int?
    let name: String?
    let title: String?
    let detailsText: String?
    
    enum CodingKeys: String, CodingKey {
        case key
        case name
        case title
        case detailsText = "details_text"
    }
}

 enum HomeSection {
    case slider
    case category(Int) 
}
