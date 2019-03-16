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

    lazy var bottomLine: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: 20, y: 0, width: contentView.frame.size.width, height: 1)
        line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1).cgColor
        return line
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .white

        lineLabel.textColor = UIColor.SA.Primary
        newTimeLabel.textColor = UIColor.SA.Primary

        contentView.layer.addSublayer(bottomLine)
    }

}
