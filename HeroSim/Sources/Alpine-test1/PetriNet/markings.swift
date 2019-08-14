//
//  markings.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

class Markings<T>{ // todo MARKING
    
    // The marking as an Array (can be changed as accessed by subscript)
    private var markings = [T]()
    
    init<I : Sequence>(markings : I) where I.Iterator.Element == T {
        for i in markings{
            self.markings.append(i)
        }
    }
    
    // Return nil if does not exist
    subscript(index: Int) -> T?{
        get{
            assert (markings.count > index && index >= 0, "Token index does not exist : \(index)")
            return (markings.count > index && index >= 0) ? markings[index] : nil
        }
//        set(value){
//            markings[index] = markings.contains(index) ? value : nil
//        }
    }
    
    // Add an element to the markings, Don't chek if already exist
    func add(expr: T){
        //if !markings.contains(expr){
            markings.append(expr)
        //}
    }
    
    // Delete an element, return nil if range is not ok.
    func del(index: Int) -> T?{
        
        let deleted = self[index] // used to check if exist and return value
        if deleted != nil{
            markings.remove(at: index)
        }
        return deleted
    }
    

    // ||||||||| Getter & Setter |||||||||||||
    public func getCardinality() -> Int {
        return markings.count
    }
}
