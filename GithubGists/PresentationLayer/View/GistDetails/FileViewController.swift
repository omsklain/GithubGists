//
//  FileViewController.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import UIKit

class FileViewController: UIViewController {
    
    @IBOutlet weak var textViewFile: UITextView!
    private var fileUrlString: String?
    
    init?(coder: NSCoder, fileUrlString: String?) {
        self.fileUrlString = fileUrlString
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFile(fileUrlString: fileUrlString ?? "No context")
    }
    
    private func getFile(fileUrlString: String) {
        textViewFile.loadFromUrl(urlString: fileUrlString)
    }

}
