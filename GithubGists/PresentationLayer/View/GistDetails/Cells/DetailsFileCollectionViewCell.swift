//
//  DetailsFileCollectionViewCell.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import UIKit

class DetailsFileCollectionViewCell: UICollectionViewCell {

    var model: File? {
        didSet {
            configure()
        }
    }
    
    @IBOutlet weak var gistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func configure() {
        if let file = model {
            gistName.text = file.filename
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow).height
        return layoutAttributes
    }
    
}
