//
//  place.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Place<T> {
    
    // Container for markings, of type T
    let markings: Markings<T>
    // Just for information purpose or display.
    var comment: String
    // The domain of the tokens (marking)
    let domain: Domain
    
    init<I : Sequence>(markings : I, domain: Domain, comment: String) where I.Iterator.Element == T {
        self.markings = Markings(markings: markings)
        self.comment = comment
        self.domain = domain
    }
    
    public func getAValue() -> T?{
        // get the first marking
        let m = markings[0]
        let isDel = markings.del(index: 0)
        assert(isDel != nil, "Value was not deleted \(self)")
        return m
    }
    
    mutating func add(token: T){
        markings.add(expr: token)
    }
    
    // Modify the comments
    mutating func setComment(comment: String){
        self.comment = comment
    }
    
//    mutating func setLinked<I:Sequence>(linkedSeq:  I) where I.Iterator.Element == Transition {
//        for i in linkedSeq{
//            self.linked.append(i)
//        }
//    }
    
    // ||||||||| Getter & Setter |||||||||||||
    public func getDomain() -> Domain {
        return self.domain
    }
}
