//
//  ReservationDetailsEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 21/09/2025.
//

import Foundation
import Alamofire

struct OrderDetailsEndPoints {
    private init() {}
}

extension OrderDetailsEndPoints {
    
    static func getOrderDetails(orderId : Int) -> Endpoint<BaseResponse<OrderDetails>>{
        return .init(
            method: .get,
            path: "order-details/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func getCancelReasons() -> Endpoint<BaseResponse<[CancelReasonModel]>>{
        return .init(
            method: .get,
            path: "cancel-reasons",
            headerType: .authorized(token: Session.token ?? "")
        )
    }


    static func cancelOrder(orderId : Int,cancelReasonId: Int ) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "cancel-order",
            body: [
                "order_id" : orderId,
                "cancel_reason_id" : cancelReasonId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func rateOrder(model : RateOrderModel) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "rate-order",
            body: [
                "order_id" : model.orderId,
                "order_rate" : model.orderRate,
                "delegate_comment" : model.delegateComment,
                "delegate_rate" : model.delegateRate,
                "car_type_rate" : model.carTypeRate
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
