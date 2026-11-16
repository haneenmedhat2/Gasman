//
//  OrdersModel.swift
//  Esterad
//
//  Created by Haneen on 30/11/2025.
//

import Foundation

enum OrderStatus: String {
    case open
    case finished
    case closed

    init(apiValue: String) {
        switch apiValue {
        case "finished-orders": self = .finished
        case "cancelled-orders": self = .closed
        default: self = .open
        }
    }

    var apiValue: String {
        switch self {
        case .open: return "current-orders"
        case .finished: return "finished-orders"
        case .closed: return "cancelled-orders"
        }
    }
    
    var stringValue: String {          
        switch self {
        case .open: return "current_orders".localized
        case .finished: return "completed_orders".localized
        case .closed: return "cancelled_orders".localized
        }
    }
}

struct OrdersResponse : Codable {
    let data : [Orders]
    let pagination : Pagination
}

struct Orders : Codable {
    let id: Int?
    let orderNum: String?
    let logo: String?
    let date: String?
    let totalPrice: String?
    let currency: String?
    let productsCategories: String?
    let status: StatusModel?
    let productsType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNum = "order_num"
        case logo
        case date
        case totalPrice = "total_price"
        case currency
        case productsCategories = "products_categories"
        case status
        case productsType = "products_type"
    }
}
