//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class NoResultsView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        return label
    }()

    lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem //
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return stack;
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        titleLabel.text = NSLocalizedString("No departures for current stop", comment: "No departures found for current stop")
        descriptionLabel.text = NSLocalizedString("The current stop didn't return any departures at this time. Please try again later, or try another stop nearby.", comment: "No departure for current stop description")

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(descriptionLabel)

        addSubview(contentStack)

        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

}
