//
//  CouponView.swift
//  GasMan
//
//  Created by Haneen on 01/03/2026.
//

import UIKit

class CouponView: UIView {

    //MARK: - Outlets -

    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet weak var activateButton: UIButton!

    //MARK: - Properties -

    var onActivate: ((String) -> Void)?
    var onClear: (() -> Void)?
    var onEmptyCoupon: (() -> Void)?

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
        let nib = UINib(nibName: "CouponView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    //MARK: - Setup -

    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }

    private func viewSetup() {
        inputContainerView.layer.cornerRadius = 8
        inputContainerView.layer.borderWidth = 1
        inputContainerView.layer.borderColor = UIColor.textFieldBorder.cgColor
        inputContainerView.clipsToBounds = true

        activateButton.layer.cornerRadius = 6
        activateButton.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        activateButton.setTitle("activate".localized, for: .normal)
        activateButton.setTitleColor(.white, for: .normal)
        activateButton.titleLabel?.font = .myMediumFont(ofSize: 13)

        couponTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc private func textFieldDidChange() {
        if couponTextField.text?.isEmpty == true {
            onClear?()
        }
    }

    //MARK: - Action -

    @IBAction func didTapActivate(_ sender: UIButton) {
        let code = couponTextField.text?.trimWhiteSpace() ?? ""
        guard !code.isEmpty else {
            onEmptyCoupon?()
            return
        }
        onActivate?(code)
        couponTextField.resignFirstResponder()
    }
}
