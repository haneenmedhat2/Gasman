//
//  RateOrderPopup.swift
//  GasMan
//
//  Created by Haneen on 03/03/2026.
//

import UIKit
import Cosmos
import Kingfisher

class RateOrderPopup: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingRowsStack: UIStackView!
    @IBOutlet weak var commentTextView: UITextView!

    //MARK: - Properties -

    var delegate: DelegateModel?
    var orderId: Int = 0
    var onConfirm: ((RateOrderModel) -> Void)?

    private let ratingItems: [(title: String, errorKey: String)] = [
        ("rate_delegate",       "please_rate_delegate"),
        ("rate_order_status",   "please_rate_order_status"),
        ("rate_vehicle_status", "please_rate_vehicle_status"),
        ("rate_app",            "please_rate_app")
    ]
    
    private var cosmosViews: [CosmosView] = []

    //MARK: - Initializer -

    init() {
        super.init(nibName: "RateOrderPopup", bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    //MARK: - Setup -

    func initialConfiguration() {
        configView()
        configureRatingRows()
        populateDelegate()
    }

    func configView() {
        view.backgroundColor = .clear
        backView.backgroundColor = .black.withAlphaComponent(0.6)
        backView.alpha = 0
        contentView.alpha = 0
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .textFieldBorder

        commentTextView.layer.cornerRadius = 12
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.textFieldBorder.cgColor
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.font = .systemFont(ofSize: 14)
        commentTextView.text = "write_your_review_here".localized
        commentTextView.textColor = .placeholderText
        commentTextView.delegate = self

        let dimTap = UITapGestureRecognizer(target: self, action: #selector(onBackViewTapped))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(dimTap)
    }

    //MARK: - Rating Rows -

    private func configureRatingRows() {
        ratingRowsStack.spacing = 16

        for (index, item) in ratingItems.enumerated() {
            let cosmos = makeCosmosView()
            cosmosViews.append(cosmos)

            let label = UILabel()
            label.text = item.title.localized
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .natural
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)

            // Top separator for every item
            ratingRowsStack.addArrangedSubview(makeSeparator())

            let rowStack = UIStackView(arrangedSubviews: [label, cosmos])
            rowStack.axis = .horizontal
            rowStack.alignment = .center
            rowStack.spacing = 8
            ratingRowsStack.addArrangedSubview(rowStack)

            // Bottom separator for the last item
            if index == ratingItems.count - 1 {
                ratingRowsStack.addArrangedSubview(makeSeparator())
            }
        }
    }

    private func makeSeparator() -> UIView {
        let sep = UIView()
        sep.backgroundColor = .textFieldBorder
        sep.translatesAutoresizingMaskIntoConstraints = false
        sep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return sep
    }

    private func makeCosmosView() -> CosmosView {
        let cosmos = CosmosView()
        cosmos.settings.updateOnTouch = true
        cosmos.settings.minTouchRating = 1
        cosmos.settings.fillMode = .full
        cosmos.settings.filledImage = UIImage(named: "filledStar")
        cosmos.settings.emptyImage = UIImage(named: "emptyStar")
        cosmos.settings.starSize = 22
        cosmos.settings.starMargin = 4
        cosmos.rating = 0
        cosmos.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        cosmos.setContentCompressionResistancePriority(.required, for: .horizontal)
        return cosmos
    }

    private func populateDelegate() {
        nameLabel.text = delegate?.name
        if let urlStr = delegate?.image, let url = URL(string: urlStr) {
            profileImageView.kf.setImage(with: url)
        }
    }

    //MARK: - Presentation -

    func appear(sender: UIViewController) {
        sender.present(self, animated: false) { self.show() }
    }

    func show() {
        UIView.animate(withDuration: 1, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }

    //MARK: - Actions -

    @IBAction func didTapConfirm(_ sender: UIButton) {
        for (index, cosmos) in cosmosViews.enumerated() {
            guard cosmos.rating > 0 else {
                show(errorMessage: ratingItems[index].errorKey.localized)
                return
            }
        }

        let commentText = commentTextView.textColor == .placeholderText ? "" : commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !commentText.isEmpty else {
            show(errorMessage: "please_write_your_comment".localized)
            return
        }

        let model = RateOrderModel(
            orderId: orderId,
            orderRate: Int(cosmosViews[1].rating),
            delegateComment: commentText,
            delegateRate: Int(cosmosViews[0].rating),
            carTypeRate: Int(cosmosViews[2].rating),
            appRate: Int(cosmosViews[3].rating)
        )

        onConfirm?(model)
        hide()
    }

    @objc private func onBackViewTapped() {
        hide()
    }
}

//MARK: - UITextViewDelegate -

extension RateOrderPopup: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "write_your_review_here".localized
            textView.textColor = .placeholderText
        }
    }
}
