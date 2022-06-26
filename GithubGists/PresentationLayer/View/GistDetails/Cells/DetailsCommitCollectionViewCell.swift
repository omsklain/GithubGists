//
//  DetailsCommitCollectionViewCell.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import UIKit

class DetailsCommitCollectionViewCell: UICollectionViewCell {

    var model: Commit? {
        didSet {
            configure()
        }
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var subString: UILabel!
    
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
        if let commit = model {
            userImage.setImageFromUrl(urlString: commit.avatarUrl)
            userName.text = commit.login
            subString.text = "[additions: \(commit.additions)] : [deletions: \(commit.deletions)]"
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
