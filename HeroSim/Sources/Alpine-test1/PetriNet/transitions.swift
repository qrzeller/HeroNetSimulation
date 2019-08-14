//
//  transitions.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation


struct Transitions {
    
    let transitions: [Transition] // How to conform to Equatable?...
    
    init(transitions: [Transition]) {
        self.transitions = transitions
    }
    
    subscript(index: Int) -> Transition? {
        get{
            assert (transitions.count > index && index >= 0, "Transition index does not exist : \(index)")
            return (transitions.count > index && index >= 0) ? transitions[index] : nil
        }
        
    }
}
