//
//  NotificationsEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 05/09/2025.
//

import Foundation
import Alamofire

struct NotificationsEndPoints {
    private init() {}
}

extension NotificationsEndPoints {
    
    
    static func notificationCount() -> Endpoint<BaseResponse<NotificationCountResponse>>{
        return .init(
            method: .get,
            path: "count-notifications",
            headerType:.authorized(token: UserDefaults.accessToken ?? "")
        )
        print("🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳\(UserDefaults.accessToken)")
    }
    
    static func getNotifications(page: Int) -> Endpoint<BaseResponse<NotificationResponse>>{
        return .init(
            method: .get,
            path: "notifications",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteNotification(notificationId:String) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .delete,
            path: "delete-notification/\(notificationId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteAllNotifications() -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .delete,
            path: "delete-notifications",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}

