//
//  CollectionHeaderView.swift
//  Esterad
//
//  Created by Haneen on 13/11/2025.
//

import Foundation
import UIKit

final class CollectionHeaderView: UICollectionReusableView {
    
    // MARK: - Properties -
    
    static let headerIdentifier = "CollectionHeaderView"
    static let elementKind = UICollectionView.elementKindSectionHeader

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup -
    
    private func setupUI() {
        backgroundColor = .clear
        titleStack.addArrangedSubview(titleLabel)
        
        addSubview(titleStack)
        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

extension CollectionHeaderView {
    
    func configure( title: String) {
        titleLabel.text = title
    }
    
}
