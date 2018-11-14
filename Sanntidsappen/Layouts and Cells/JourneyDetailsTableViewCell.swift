//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class JourneyDetailsTableViewCell: UITableViewCell {

    static let identifier = "JourneyDetailsTableViewCell"

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return label
    }()

    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.textColor = .SAPink
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView()
        stackView.axis = .horizontal

        contentView.addSubview(timeStampLabel)
        contentView.addSubview(titleLabel)

        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
        timeStampLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        timeStampLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: timeStampLabel.trailingAnchor, constant: 48).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

