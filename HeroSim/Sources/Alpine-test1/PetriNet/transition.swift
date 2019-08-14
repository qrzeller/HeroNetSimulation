//
//  transition.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Transition<In, Out>{
    
    // TODO
    let transitionGuard: ([In]) -> Bool
    
    let arcsIn :[Arc<In, In>] //assume we do not change the type in "in arcs" !
    let arcsOut :[Arc<Any, Out>]
    var function : Arc<(In)-> Out, (In)-> Out>?
    
    var enabled = true
    
    init(transitionGuard: @escaping ([In]) -> Bool, arcsIn: [Arc<In, In>], arcsOut: [Arc<Any, Out>], function: Arc<(In)-> Out, (In)-> Out>?) {
        self.transitionGuard    = transitionGuard
        self.arcsIn             = arcsIn
        self.arcsOut            = arcsOut
        
        self.function = function
    }
    
    
    public mutating func fire() -> Bool{
        if !enabled{ return false }
        
        // marking from place, executed by the labels
        var executedToken = [Any]()
        for var i in arcsIn{
            
            if let inMark = i.execute(){ // Assume type not changed (In == Out), as arc is way in. see line 15
                print("Treating \(i.name) , \(inMark):")
                
                executedToken.append(inMark)
            } else {
                print("One label returned nil, " + i.name)
                return false
            }
        }
        
        let fun = self.function!.execute()!
        executedToken.append(fun)
        
        // -----------------------------
        
        
        // TODO : we need to choose a subset of the variable. The in parameter are not everything for sure !!!!
        
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
}
