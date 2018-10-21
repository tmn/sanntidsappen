//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

protocol DepartureDetailsCollectionViewHeaderCellDelegate: class {
    func expandSectionListWith(number: Int)
}

class DepartureDetailsCollectionViewHeaderCell: UICollectionViewCell {
    static let identifier: String = "DepartureDetailsCollectionViewHeaderCell"

    weak var delegate: DepartureDetailsCollectionViewHeaderCellDelegate?

    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!

    var sectionNumber: Int = -1
    var compassDirection: CompassDirection? {
        didSet {
            if let direction = compassDirection?.bearing {
                directionLabel.text = "Direction: \(direction)"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        sectionHeaderLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        expandButton.tintColor = .SAPink
        expandButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        directionLabel.text = ""
        sectionHeaderLabel.text = ""
    }

    @IBAction func seeAllClick(_ sender: Any) {

        delegate?.expandSectionListWith(number: self.sectionNumber)
    }

}
