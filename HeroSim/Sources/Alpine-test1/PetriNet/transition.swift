//
//  transition.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Transition<In, Out>{
    
    // TODO
    let transitionGuard: ([In]) -> Bool//([In]) -> Bool
    
    var arcsIn  :[ArcIn<In, In>] // TODO only binding
    var arcsOut :[ArcOut<In, Out>]
    
    var enabled = true
    
    init(transitionGuard: @escaping ([In]) -> Bool, arcsIn: [ArcIn<In, In>], arcsOut: [ArcOut<In, Out>]) {
        self.transitionGuard    = transitionGuard
        self.arcsIn             = arcsIn
        self.arcsOut            = arcsOut
    }
    
    
    public mutating func fire() -> Bool{
        if !enabled{ return false }
        
        // marking from place, executed by the labels
        var executedToken         = [In]() // labels needs any
        
        for var i in arcsIn{
            
            if let inMark = i.execute(){ // Assume type not changed (In == Out), as arc is way in. see line 15
                print("Treating \(i.name) , \(inMark):")
                
                executedToken.append(inMark)
            } else {
                print("One label returned nil, " + i.name)
                resetState(tokens: executedToken)
                return false
            }
        }
        
        // ----------------------------- Check guards
        // If guard did not validate, return token to state.
        if !transitionGuard(executedToken) {
            self.resetState(tokens: executedToken)
            return false
        }
        
        
        
        // _____________________________
        
        for var i in arcsOut{
            if let outMark = i.execute(transitionParams: executedToken){
                print("The execution \(i.name) returned: \(outMark) ")
            } else {
                print("The execution \(i.name) returned nil !")
            }
        }
        
        return true // improove
    }
    
    
    public mutating func disable(){
        self.enabled = false
    }
    
    public mutating func enable(){
        self.enabled = true
    }
    
    // Put back token in the places
    private mutating func resetState(tokens: [In]) -> Void{
        print("Guard fails, refill value")
        for i in 0 ..< tokens.count{ // tokens count because it can be parially executed
            arcsIn[i].connectedPlace.add(token: tokens[i])
        }
    }
}
