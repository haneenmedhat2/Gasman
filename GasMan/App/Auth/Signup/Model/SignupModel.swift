//
//  SignupModel.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation


//MARK: - SignupModel -

struct SignupModel : Codable {
    let name : String?
    let email : String?
    let phone : String?
    let countryKey : String?
    let cityId : Int?
    let password : String?
    let confirmPassword : String?
    var avatar : Data? = nil
    
    var uploadData: [UploadData] {
        var files = [UploadData]()
        if let avatarData = avatar {
            files.append(UploadData(
                key: "image",
                data: avatarData,
                mimeType: .jpeg,
                fileName: "\(Date().timeIntervalSince1970).jpeg"
            ))
        }
        return files
    }
}

// MARK: - Area Model -

struct AreaModel: Codable {
    let id: Int?
    let name: String?
}

extension AreaModel : SelectionModelPicker {
    var pickerId: Int { id  ?? 0 }
    var pickerName: String { name ?? "" }
}

// MARK: - User -

struct User: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let countryKey: String?
    let phone: String?
    let changedPhone: String?
    let image: String?
    let lat: String?
    let long: String?
    let address: String?
    let rate: String?
    let approve: String?
    let wallet: String?
    let totalBills: String?
    let totalDeliveryFees: String?
    let numOrders: String?
    let numComments: String?
    let accType: String?
    let newOrdersNotify: Bool?
    let offersNotify: Bool?
    let timeZone: String?
    let lang: String?
    let isNotify: Bool?
    let date: String?
    let city : AreaModel?
    let token : String?
    let fullPhone : String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, image, lat, long, address, rate, approve, wallet, date, city,token
        case countryKey = "country_key"
        case changedPhone = "changed_phone"
        case totalBills = "total_bills"
        case totalDeliveryFees = "total_delivery_fees"
        case numOrders = "num_orders"
        case numComments = "num_comments"
        case accType = "acc_type"
        case newOrdersNotify = "new_orders_notify"
        case offersNotify = "offers_notify"
        case timeZone = "time_zone"
        case lang
        case isNotify = "is_notify"
        case fullPhone = "full_phone" 
    }
}

