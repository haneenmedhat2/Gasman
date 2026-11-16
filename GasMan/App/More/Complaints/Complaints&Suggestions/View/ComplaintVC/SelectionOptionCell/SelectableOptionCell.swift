//
//  SelectableOptionCell.swift
//  GasMan
//
//  Created by Haneen on 26/02/2026.
//

import UIKit

class SelectableOptionCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var selectionIcon: UIImageView!
    @IBOutlet weak var titleLAbel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(model : SelectionOptionType , isSelected : Bool){
        titleLAbel.text = model.title
        if isSelected {
            selectionIcon.tintColor = .main
            selectionIcon.image = UIImage(systemName: "circle.inset.filled")
            titleLAbel.textColor = .black
        } else {
            selectionIcon.tintColor = .hint
            selectionIcon.image = UIImage(systemName: "circle")
            titleLAbel.textColor = .hint

        }
    }
}
