//
//  Dynamic.swift
//  GithubGists
//
//  Created by Константин Туголуков on 23.06.2022.
//

import Foundation

class Dynamic<T>{
    
    typealias Listener = (T) -> ()
    
    private var listener: Listener?
    
    var value: T {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?){
        self.listener = listener
    }
    
}
