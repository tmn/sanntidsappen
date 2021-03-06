//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class DepartureDetailsCollectionViewCell: UICollectionViewCell {

    static var identifier: String = "DepartureDetailsCollectionViewCell"

    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var aimedTimeLabel: UILabel!
    @IBOutlet weak var newTimeLabel: UILabel!
    @IBOutlet weak var expectedTimeLable: UILabel!

    lazy var topLine: CALayer = {
        let line = CALayer()
        line.backgroundColor = UITableView().separatorColor?.cgColor
        return line
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.addSublayer(topLine)
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        topLine.frame = CGRect(x: 20, y: 0, width: layoutAttributes.size.width - 20, height: 0.4)
        return layoutAttributes
    }

}
