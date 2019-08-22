//
//  place.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Place<T>: CustomStringConvertible {
    var description: String {
        return """
        Place :
            Tokens : \(tokens)
            Domain : \(domain)
            Info   : \(comment)
        """
    }
    
    // Container for markings, of type T
    let tokens: Tokens<T>
    // Just for information purpose or display.
    var comment: String
    // The domain of the tokens (marking)
    let domain: Domain
    
    init<I : Sequence>(tokens : I, domain: Domain, comment: String) where I.Iterator.Element == T {
        self.tokens = Tokens(tokens: tokens)
        self.comment = comment
        self.domain = domain
    }
    
    public func getAValue() -> T?{
        // get the first marking
        let m = tokens[0]
        _ = tokens.del(index: 0)
        return m
    }
    
    // Add a token to the place
    mutating func add(token: T){
        tokens.add(expr: token)
    }
    
    
    // ||||||||| Getter & Setter |||||||||||||
    public func getDomain() -> Domain {
        return self.domain
    }
    
    
    // Modify the comments
    mutating func setComment(comment: String){
        self.comment = comment
    }
}
