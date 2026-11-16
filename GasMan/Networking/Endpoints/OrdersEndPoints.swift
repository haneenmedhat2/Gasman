//
//  ReservationsEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 21/09/2025.
//

import Foundation
import Alamofire

struct OrdersEndPoints {
    private init() {}
}

extension OrdersEndPoints {
    
    static func getOrders(path : String, page : Int) -> Endpoint<BaseResponse<OrdersResponse>>{
        return .init(
            method: .get,
            path: path,
            queries: [
                "page" : page
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}

