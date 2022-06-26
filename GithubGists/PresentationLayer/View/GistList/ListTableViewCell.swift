//
//  ListTableViewCell.swift
//  GithubGists
//
//  Created by Константин Туголуков on 23.06.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    var model: Gist? {
        didSet{
            self.configure()
        }
    }
    
    private(set) lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private(set) lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
    
    private func setLayouts() {
        contentView.addSubview(userImageView)
        contentView.addSubview(labelStackView)
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            labelStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func configure() {
        if let gist = model {
            titleLabel.text = gist.firstFileName ?? "No file name"
            subTitleLabel.text = gist.login + " [files gists: \(gist.files?.count ?? 0)]"
            userImageView.setImageFromUrl(urlString: gist.avatarUrl)
        }
    }
    
}
