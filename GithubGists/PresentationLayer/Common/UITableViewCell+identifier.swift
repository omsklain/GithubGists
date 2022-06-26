//
//  UITableViewCell+identifier.swift
//  GithubGists
//
//  Created by Константин Туголуков on 23.06.2022.
//

import UIKit

extension UITableViewCell {
    class var identifier: String { return String(describing: self) }
}
