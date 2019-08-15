//
//  tokens.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

class Tokens<T>: CustomStringConvertible{
    var description: String { return tokens.description }
    // todo MARKING
    
    // The token set as an Array (can be changed as accessed by subscript)
    private var tokens = [T]()
    
    init<I : Sequence>(markings : I) where I.Iterator.Element == T {
        for i in markings{
            self.tokens.append(i)
        }
    }
    
    // Return nil if does not exist
    subscript(index: Int) -> T?{
        get{
            assert (tokens.count > index && index >= 0, "Token index does not exist : \(index)")
            return (tokens.count > index && index >= 0) ? tokens[index] : nil
        }
//        set(value){
//            markings[index] = markings.contains(index) ? value : nil
//        }
    }
    
    // Add an element to the token set, Don't chek if already exist
    func add(expr: T){
        //if !markings.contains(expr){
            tokens.append(expr)
        //}
    }
    
    // Delete an element, return nil if range is not ok.
    func del(index: Int) -> T?{
        
        let deleted = self[index] // used to check if exist and return value
        if deleted != nil{
            tokens.remove(at: index)
        }
        return deleted
    }
    

    // ||||||||| Getter & Setter |||||||||||||
    public func getCardinality() -> Int {
        return tokens.count
    }
}
