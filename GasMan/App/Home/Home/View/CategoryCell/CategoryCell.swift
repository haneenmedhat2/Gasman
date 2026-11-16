//
//  CategoryCell.swift
//  Esterad
//
//  Created by Haneen on 12/11/2025.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var productTypeView: UIView!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var orderNowLabel: UILabel!
    
    //MARK: - Properties -
    
    
    //MARK: - Nib Configuration -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    //MARK: - Cell Setup -
    
    func setupCell(model : Products){
        
        productTypeLabel.text = model.type?.detailsText
        productNameLabel.text = model.title
        productPriceLabel.text = model.price?.toPrice
        UILabel.underline(orderNowLabel)
        
        productImage.kf.setImage(with: URL(string: model.image ?? ""),options: [.onFailureImage(UIImage(resource: .CARD ))])
        
        if model.type?.key == 0 {
            productTypeLabel.textColor = .white
            productTypeView.backgroundColor = .darkView
        } else {
            productTypeLabel.textColor = .main
            productTypeView.backgroundColor = .mainWithAlpha
        }
    }
}
