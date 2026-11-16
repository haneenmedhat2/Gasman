//
//  UpdateProfileModel.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import Foundation

struct UpdateProfileModel: Codable {
    var image : Data? = nil
    var name : String?
    var cityId : Int?
    var email : String?
    
    var uploadData: [UploadData] {
        var files = [UploadData]()
        if let imageData = image {
            files.append(UploadData(
                key: "image",
                data: imageData,
                mimeType: .jpeg,
                fileName: "\(Date().timeIntervalSince1970).jpeg"
            ))
        }
        return files
    }
}
