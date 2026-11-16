//
//  SavedAddresses.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//

import Foundation


struct SavedAddressesResponse : Codable {
    let pagination : Pagination?
    let data : [SavedAddresses]
}

struct SavedAddresses : Codable {
    
    let id : Int?
    let name : String?
    let streetName : String?
    let buildingNumber : String?
    let city : AreaModel?
    let mapDesc : String?
    let lat : Double?
    let lng : Double?
    var isSelected : Bool = false
    
    enum CodingKeys : String , CodingKey {
        case id , name ,city ,lat , lng
        case streetName = "street_name"
        case buildingNumber  = "building_number"
        case mapDesc = "map_desc"
    }
    
}
