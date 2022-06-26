//
//  DetailsTopCollectionViewCell.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import UIKit

class DetailsTopCollectionViewCell: UICollectionViewCell {
    
    var model: Gist? {
        didSet {
            configure()
        }
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLogin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        userImage.layer.cornerRadius = userImage.frame.width / 2.0
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.lightGray.cgColor
        userImage.clipsToBounds = true
    }
    
    private func configure() {
        if let gist = model {
            userImage.setImageFromUrl(urlString: gist.avatarUrl)
            userLogin.text = gist.login
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

