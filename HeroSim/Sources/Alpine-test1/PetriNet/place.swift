//
//  place.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Place<T: Equatable>: CustomStringConvertible {
    var description: String {
        return """
        📓 Place :
                Tokens : \(tokens)
                Domain : \(domain)
                Name   : \(name)
        """
    }
    
    // Container for markings, of type T
    let tokens: Tokens<T>
    // Just for information purpose or display.
    var name: String
    // The domain of the tokens (marking)
    let domain: Domain
    
    init<I : Sequence>(tokens : I, domain: Domain, name: String) where I.Iterator.Element == T {
        self.tokens = Tokens(tokens: tokens)
        self.name = name
        self.domain = domain
    }
    
    // get the first marking
    public func getAValue() -> T?{
        let m = tokens[0]
        _ = tokens.del(index: 0)
        return m
    }
    
    // get a random value in the tokens of self
    public func getRandomValue() -> T?{
        let card = tokens.getCardinality()
        if card < 1 {return nil}
        let i = Int.random(in: 0..<card)
        let m = tokens[i]
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
        self.name = comment
    }
}
