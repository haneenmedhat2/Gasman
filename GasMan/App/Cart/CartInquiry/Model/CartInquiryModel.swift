//
//  CarInquiryModel.swift
//  GasMan
//
//  Created by Haneen on 25/02/2026.
//

import Foundation

struct CreateOrderModel : Codable {
    var locationId : Int?
    var couponNum : String?
    var payType : Int?
    var notes : String?
    var userPhone : String?
    var neighborhoodId : Int?
    var lat : Double?
    var lng : Double?
    var mapDesc : String?
}

struct CartInquiryResponse: Codable {
    let status: String?
    let productsPrice: String?
    let vatAmount: String?
    let shippingPrice: String?
    let totalPrice: String?
    let couponAmount: String?
    let currency: String?
    let vatRatio: String?
    let locationName : String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case productsPrice = "products_price"
        case vatAmount = "vat_amount"
        case shippingPrice = "shipping_price"
        case totalPrice = "total_price"
        case couponAmount = "coupon_amount"
        case currency
        case vatRatio = "vat_ratio"
        case locationName = "location_name"
    }
}

extension CartInquiryResponse {
    
    func getDataSource(numOfProducts : Int) -> [KeyValueModel] {
        var items: [KeyValueModel] = [
            KeyValueModel(title: "delivery_address".localized, value: locationName),
            KeyValueModel(title: "number_of_products".localized, value: numOfProducts.toString() + " " + "productss".localized),
            KeyValueModel(title: "products_price".localized, value: productsPrice?.toPrice),
            KeyValueModel(title: "delivery_price".localized ,value: shippingPrice?.toPrice),
            KeyValueModel(title: "vat".localized ,value: vatAmount?.toPrice)
        ]
        if let couponAmount, couponAmount != "0.00" {
            items.append(KeyValueModel(title: "discount_coupon".localized, value: couponAmount.toPrice))
        }
        items.append(KeyValueModel(title: "total_price".localized, value: totalPrice?.toPrice))
        return items
    }
}

struct KeyValueModel{
    var title: String?
    var value: String?
}
