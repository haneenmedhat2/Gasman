//
//  HomeEndPoints.swift
//  Esterad
//
//  Created by Haneen on 08/09/2025.
//

import Foundation
import Alamofire

struct HomeEndPoints {
    private init() {}
}

extension HomeEndPoints {
    
    static func getHomeData() -> Endpoint<BaseResponse<HomeResponse>>{
        return .init(
            method: .get,
            path: "app-home-page",
            queries: [
                "city_id" : Session.user?.city?.id
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getProductDetails(id : Int ) -> Endpoint<BaseResponse<ProductDetailsResponse>>{
        return .init(
            method: .post,
            path: "product-details",
            body: [
                "product_id" : id
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
