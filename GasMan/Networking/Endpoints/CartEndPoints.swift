//
//   CartEndPoints.swift
//  GasMan
//
//  Created by Haneen on 25/02/2026.
//


import Foundation
import Alamofire

struct CartEndPoints {
    private init() {}
}

extension CartEndPoints {
    
    
    static func addToCart(productId : Int , quantity : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "add-update-cart",
            body: [
                "product_id": productId,
                "qty": quantity
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func showCartData() -> Endpoint<BaseResponse<[CartResponse]>>{
        return .init(
            method: .get,
            path: "show-cart",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteCart(cartId : Int) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delete-cart",
            body: [
                "cart_id" : cartId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getNeighborhoods(cityId : Int) -> Endpoint<BaseResponse<[AreaModel]>>{
        return .init(
            method: .get,
            path: "neighborhoods/\(cityId)"
        )
    }

    static func getCartInquiry(model : CreateOrderModel) -> Endpoint<BaseResponse<CartInquiryResponse>>{
        return .init(
            method: .post,
            path: "cart-inquiry",
            body: [
                "location_id" : model.locationId,
                "coupon_num" : model.couponNum,
                "lat" : model.lat,
                "lng" : model.lng,
                "map_desc" : model.mapDesc
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func createOrder(model : CreateOrderModel) -> Endpoint<BaseResponse<Int>>{
        return .init(
            method: .post,
            path: "create-order",
            body: [
                "location_id" : model.locationId,
                "coupon_num" : model.couponNum,
                "pay_type" : model.payType,
                "notes" : model.notes,
                "user_phone" : model.userPhone,
                "neighborhood_id" : model.neighborhoodId,
                "lat" : model.lat,
                "lng" : model.lng,
                "map_desc" : model.mapDesc
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
