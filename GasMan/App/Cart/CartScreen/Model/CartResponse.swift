//
//  CartResponse.swift
//  GasMan
//
//  Created by Haneen on 25/02/2026.
//


// MARK: - CartResponse -

struct CartResponse: Codable {
    let totalPrice: String?
    let totalQty: Int?
    let currency: String?
    let items: [CartItem]?
    let orderEndTime : String?
    let orderStartTime : String?
  
    
    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case totalQty = "total_qty"
        case currency
        case items
        case orderEndTime = "order_end_time"
        case orderStartTime = "order_start_time"
    }
}

// MARK: - CartItem -

struct CartItem: Codable {
    var cartId: Int?
    var productId: Int?
    var title: String?
    var productTitle: String?
    var image: String?
    var price: String?
    var qtyPrice: String?
    var currency: String?
    var qty: Int?
    var type: String?
    
    enum CodingKeys: String, CodingKey {
        case cartId = "cart_id"
        case productId = "product_id"
        case title
        case productTitle = "product_title"
        case image
        case price
        case qtyPrice = "qty_price"
        case currency
        case qty
        case type
    }
}

