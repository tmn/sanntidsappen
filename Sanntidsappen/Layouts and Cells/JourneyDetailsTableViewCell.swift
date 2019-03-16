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
        label.textColor = UIColor.SA.Primary
        return label
    }()

    lazy var journeyLine: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: 84, y: 0, width: 3, height: 50)
        line.backgroundColor = UIColor.SA.LightGray.cgColor
        return line
    }()

    lazy var journeyPoint: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: 85.5, y: 50/2), radius: CGFloat(7), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.SA.LightGray.cgColor

        return shapeLayer
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView()
        stackView.axis = .horizontal

        contentView.addSubview(timeStampLabel)
        contentView.addSubview(titleLabel)

        contentView.layer.addSublayer(journeyLine)
        contentView.layer.addSublayer(journeyPoint)

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

