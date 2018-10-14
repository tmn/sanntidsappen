//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class DepartureSearchResultCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "DepartureSearchResultViewController"

    var stop: Stop?

    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .SAPink
        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        return label
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height))
        stackView.frame.size.width = stackView.frame.size.width - 40
        stackView.axis = .vertical
        return stackView
    }()

    lazy var bottomLine: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: 20, y: 0, width: contentView.frame.size.width-40, height: 1)
        line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1).cgColor
        return line
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(locationLabel)

        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

        contentView.layer.addSublayer(bottomLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
