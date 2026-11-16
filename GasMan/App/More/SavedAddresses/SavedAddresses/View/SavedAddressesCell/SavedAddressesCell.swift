//
//  SavedAddressesCell.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//

import UIKit

class SavedAddressesCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var addressDescLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    //MARK: - Properties -
    
    var model : SavedAddresses?
    var delegate : SavedAddressesCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Cell setup -

    func setupCell(model : SavedAddresses){
        self.model = model
        nameLabel.text = model.name
        streetLabel.text = (model.streetName ?? "") + "/" + "building_number_prefix".localized + " " + (model.buildingNumber ?? "")
        addressDescLabel.text = model.mapDesc
        
        let isSelected = model.isSelected
        containerStackView.layer.borderColor = isSelected ? UIColor.main.cgColor : UIColor.textFieldBorder.cgColor
        deleteButton.isHidden = !isSelected
        updateButton.isHidden = !isSelected
    }
    

    //MARK: - Actions -

    @IBAction func didTapDelete(_ sender: UIButton) {
        delegate?.didTapDeleteBtn(id: model?.id ?? 0)
    }
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        guard let model = model else { return }
        delegate?.didTapUpdateBtn(model : model)
    }
}

protocol SavedAddressesCellProtocol : AnyObject {
    func didTapDeleteBtn(id : Int)
    func didTapUpdateBtn(model : SavedAddresses)
}
