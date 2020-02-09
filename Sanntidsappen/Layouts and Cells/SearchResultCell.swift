//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2019 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class SearchResultCell: UICollectionViewCell {

    static let identifier = "SearchResultCell"

    var stop: Stop?

    @IBOutlet weak var stopNameLabel: UILabel!
    @IBOutlet weak var stopLocationLabel: UILabel!

    lazy var topLine: CALayer = {
        let line = CALayer()
        line.backgroundColor = UITableView().separatorColor?.cgColor
        return line
    }()

    override func awakeFromNib() {
        contentView.layer.addSublayer(topLine)

        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .systemBackground
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        topLine.frame = CGRect(x: 20, y: 0, width: layoutAttributes.size.width - 20, height: 0.4)

        return layoutAttributes
    }
    
}
