//
//  transition.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Transition<In, Out>{
    
    // TODO
    let transitionGuard: ([String: In]) -> Bool//([In]) -> Bool
    
    var arcsIn  :[ArcIn<In>] // TODO only binding
    var arcsOut :[ArcOut<In, Out>]
    
    var enabled = true
    
    init(transitionGuard: @escaping ([String: In]) -> Bool, arcsIn: [ArcIn<In>], arcsOut: [ArcOut<In, Out>]) {
        self.transitionGuard    = transitionGuard
        self.arcsIn             = arcsIn
        self.arcsOut            = arcsOut
    }
    
    
    public mutating func fire() -> Bool{
        if !enabled{ return false }
        
        // marking from place, executed by the labels
        var executedToken         = [String: In]()
        var reset = false
        for var i in arcsIn{
            let inMarks = i.execute()
            for inMark in inMarks{
                if inMark.value != nil{
                    executedToken[inMark.key] = inMark.value
                } else { // probably mean that we have not enough token in our place
                    print("One binding could not be performed, Arc:\(i.name), \(inMark), probably no more token")
                    reset = true // because we need to fill all variable in order to reset them
                }
            }
            
            if reset { // some arc failed, reset state
                resetState(tokens: executedToken)
                return false
            }
        }
        
        // ---------------- Check guards -------------------------------
        // If guard did not validate, return token to state.
        if !transitionGuard(executedToken) {
            self.resetState(tokens: executedToken)
            return false
        }
        
        // _______________ Execute out arcs _____________________________
        
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
    private mutating func resetState(tokens: [String: In]) -> Void{
        print("Refill values: \(tokens)")
        
        for i in tokens{
            for var arc in arcsIn{
                if( arc.bindName.contains(where: {$0 == i.key})){ // if the mapping belong to this arc
                    arc.connectedPlace.add(token: i.value) // add the token to the connected place
                    print("Token \(i.value) put back to arc \(arc.name)")
                }
            }
        }
    }
}
