//
//  ManageAddress.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//

import Foundation

struct ManageAddress : Codable {
    let name : String?
    let mapDesc : String?
    let lat : Double?
    let lng : Double?
    let cityId : Int?
    let buildingNumber : String?
    let streetName : String?
    let locationId : Int?
}

enum ManageAddressMode {
    case addNewAddress
    case updateAddress
    
    var title : String {
        switch self {
        case .addNewAddress:
            return "add_address".localized
        case .updateAddress:
            return "edit_address".localized
        }
    }
    
    var buttonTitle : String {
        switch self {
        case .addNewAddress:
            return "confirm_address".localized
        case .updateAddress:
            return "save_changes".localized
        }
    }
}
