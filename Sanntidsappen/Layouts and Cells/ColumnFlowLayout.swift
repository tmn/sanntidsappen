//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {

    private var _minimumLineSpacing: CGFloat?

    private var topInset: CGFloat?

    private var leftInset: CGFloat?

    private var rightInset: CGFloat?

    private var cellHeight: CGFloat?

    init(minimumLineSpacing: CGFloat? = 0.0, leftInset: CGFloat? = 0.0, rightInset: CGFloat? = 0.0, cellHeight: CGFloat? = 60.0) {
        self._minimumLineSpacing = minimumLineSpacing
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellHeight = cellHeight

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let cv = collectionView else { return }

        self.itemSize = CGSize(width: cv.bounds.inset(by: cv.layoutMargins).size.width, height: self.cellHeight!)
        self.minimumLineSpacing = self._minimumLineSpacing!
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: self.leftInset!, bottom: self.minimumInteritemSpacing, right: self.rightInset!)

        if #available(iOS 11.0, *) {
            self.sectionInsetReference = .fromSafeArea
        }
    }

}
