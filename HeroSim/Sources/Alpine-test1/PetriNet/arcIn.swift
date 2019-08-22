//
//  arcIn.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 11.08.19.
//

import Foundation

struct ArcIn<T>: CustomStringConvertible{
    var description: String{
        return """
        ArcIn :
            Name: \(name)
            From place : \(connectedPlace.comment)
            Binding : \(bindName)
        """
    }
    
    var connectedPlace: Place<T>

    let bindName: [String]
    let name : String
    
    init(label: String, connectedPlace: Place<T>, name: String = "") {
        
        self.bindName = label.components(separatedBy: CharacterSet([" ", ",", "\t", "\n",])).filter { $0 != "" }
        
        self.name = name
        self.connectedPlace = connectedPlace
        
    }

    mutating func execute() -> [String: T?]{
        var binding = [String:T?]()
        
        for i in bindName{
            let param = self.connectedPlace.getAValue()
            binding[i] = param
        }
        
        return binding

        
    }
}
