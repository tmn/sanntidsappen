//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class DepartureDetailsViewController: UIViewController {

    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout = ColumnFlowLayout()

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.alwaysBounceVertical = true

        view.addSubview(collectionView)

        collectionView.register(UINib(nibName: DepartureDetailsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DepartureDetailsCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

}


// MARK: - Delegate

extension DepartureDetailsViewController: UICollectionViewDelegate {

}


// MARK: - Data Source

extension DepartureDetailsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepartureDetailsCollectionViewCell.identifier, for: indexPath) as! DepartureDetailsCollectionViewCell
        return cell
    }

}
