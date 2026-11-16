//
//  GuestLoginPopup.swift
//  Waraqa
//
//  Created by Haneen on 05/10/2025.
//

import UIKit

class GuestLoginPopup: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!

    //MARK: - Initializer  -

    init() {
        super.init(nibName: "GuestLoginPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    //MARK: - View Configuration -

    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 24
        self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let dimTap = UITapGestureRecognizer(target: self, action: #selector(didTapBackView))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(dimTap)

        setupPromptLabel()
    }

    private func setupPromptLabel() {
        let prefix = "guest_prompt_prefix".localized
        let link   = "guest_prompt_link".localized
        let suffix = "guest_prompt_suffix".localized

        let attributed = NSMutableAttributedString()

        let baseAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.label
        ]
        let linkAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.main,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.main
        ]

        attributed.append(NSAttributedString(string: prefix, attributes: baseAttrs))
        attributed.append(NSAttributedString(string: link,   attributes: linkAttrs))
        attributed.append(NSAttributedString(string: suffix, attributes: baseAttrs))

        let label = UILabel()
        label.attributedText = attributed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPrompt))
        label.addGestureRecognizer(tap)

        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }

    func appear(sender: UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
    }

    func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    func hide(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }

    //MARK: - Actions -

    @objc private func didTapPrompt() {
        hide()
        let vc = LoginVC(viewModel: LoginVM())
        let nav = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }

    @objc func didTapBackView() {
        hide()
    }
}
