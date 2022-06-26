//
//  DetailsHeaderCollectionReusableView.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import UIKit

class DetailsHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String) {
        titleLabel.text = title.uppercased()
    }
    
}
