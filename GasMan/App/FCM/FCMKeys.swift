//
//  FCMKeys.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation

enum FCMValueKeys: String {
    case id
    case type
    case orderId = "order_id"
    case ticketId = "ticket_id"
    case titleEn = "title_en"
    case titleAr = "title_ar"
    case meesageEn = "message_en"
    case messageAr = "message_ar"
    case senderName = "sender_name"
}

enum NotificationType: String, Codable {
    case deleteNotify = "delete_notify"
    case blockNotify = "block_notify"
    case adminNotify = "admin_notify"
    case ticketReply = "ticket_reply"
    case ticketInprogress = "ticket_inprogress"
    case refundAmount = "refund_amount"
    case finishOrder = "finish_order"
    case onwayOrder = "onway_order"
    case delegateAcceptOrderToUser = "delegate_accept_order_to_user"
    case delegateRateOrderToUser = "delegate_rate_order_to_user"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = NotificationType(rawValue: rawValue) ?? .unknown
    }
}
