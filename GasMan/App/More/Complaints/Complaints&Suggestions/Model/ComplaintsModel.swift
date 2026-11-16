//
//  ComplaintsModel.swift
//  Esterad
//
//  Created by Haneen on 06/11/2025.
//

import Foundation
import UIKit


struct ComplaintsModel : Codable {
    let subject : String?
    let complaint : String?
    let type : String?
    
    var images: [Data] = []
    
    var uploadData: [UploadData] {
        var files = [UploadData]()
        
        for (index, imageData) in images.enumerated() {
            files.append(
                UploadData(
                    key: "images[\(index)]",
                    data: imageData,
                    mimeType: .jpeg,
                    fileName: "image_\(index)_\(Date().timeIntervalSince1970).jpeg"
                )
            )
        }
        
        return files
    }
}

enum SelectionOptionType : CaseIterable {
    case complaint
    case suggestion
    case electronic
    case cashOnDelivery
    
    var title : String {
        switch self {
        case .complaint:
            return "complaint".localized
        case .suggestion:
            return "suggestion".localized
        case .electronic:
            return "electronic_payment".localized
        case .cashOnDelivery:
            return "cash_on_delivery".localized
        }
    }
    
    var apiValue : String {
        switch self {
        case .complaint:
            return "complaint"
        case .suggestion:
            return "message"
        case .electronic:
            return "0"
        case .cashOnDelivery:
            return "1"
        }
    }
}

struct ComplaintImageItem {
    let image: UIImage
    let data: Data
}
