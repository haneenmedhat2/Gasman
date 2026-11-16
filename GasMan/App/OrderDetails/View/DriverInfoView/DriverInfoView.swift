//
//  DriverInfoView.swift
//  GasMan
//
//  Created by Haneen on 02/03/2026.
//

import UIKit
import Kingfisher

class DriverInfoView: UIView {

    //MARK: - Outlets -

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var plateNumLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    
    //MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    //MARK: - XIB Loading -

    private func configureView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DriverInfoView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    //MARK: - Setup -

    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }

    private func viewSetup() {
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .textFieldBorder
    }

    //MARK: - Configure -

    func configure(delegate: DelegateModel) {
        nameLabel.text = delegate.name
        phoneLabel.text = delegate.phone
        plateNumLabel.text = "plate_number".localized + ": " + (delegate.vehicleLicensePlate ?? "")
        vehicleTypeLabel.text = "vehicle_type".localized + ": " +  ( delegate.carType ?? "" )
        
        if let urlStr = delegate.image, let url = URL(string: urlStr) {
            profileImageView.kf.setImage(with: url)
        }
    }
}
