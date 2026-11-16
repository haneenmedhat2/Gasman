//
//  OrderCell.swift
//  Esterad
//
//  Created by Haneen on 30/11/2025.
//

import UIKit

class OrderCell: UITableViewCell {

    //MARK: - Outlets -

    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var statusBadgeView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var viewOrderBtn: UIButton!

    //MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }

    //MARK: - Setup -

    private func viewSetup() {
        selectionStyle = .none

        containerStackView.layer.cornerRadius = 16
        containerStackView.layer.borderWidth = 1
        containerStackView.layer.borderColor = UIColor.textFieldBorder.cgColor
        containerStackView.layer.masksToBounds = true

        statusBadgeView.layer.cornerRadius = 8
        
        priceLabel.textColor = .main

        viewOrderBtn.setTitleColor(.secondaryDarkFont, for: .normal)
        viewOrderBtn.setTitle("view_more".localized, for: .normal)
    }

    //MARK: - Configure -

    func setupCell(model: Orders) {
        orderIdLabel.text = "order_num".localized + "\(model.orderNum ?? "\(model.id ?? 0)")"
        orderTypeLabel.text = "order_type".localized + " : " + (model.productsType ?? "")
        categoryLabel.text = "product_type".localized + " : " + (model.productsCategories ?? "")
        statusLabel.text = model.status?.title
        priceLabel.text = model.totalPrice?.toPrice

    }

    func configureStatusBadge(for status: OrderStatus) {
        switch status {
        case .open:
            statusBadgeView.backgroundColor = .halfMainAlpha
            statusLabel.textColor = .black
        case .finished:
            statusBadgeView.backgroundColor = .main
            statusLabel.textColor = .white
        case .closed:
            statusBadgeView.backgroundColor = UIColor(red: 0.90, green: 0.18, blue: 0.18, alpha: 1.0)
            statusLabel.textColor = .white
        }
    }
}
