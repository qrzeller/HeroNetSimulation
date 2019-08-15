//
//  transition.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Transition<In, Out>{
    
    // TODO
    let transitionGuard: ([Any]) -> Bool//([In]) -> Bool
    
    var arcsIn :[Arc<In, In>] //assume we do not change the type in "in arcs" !
    var arcsOut :[Arc<Any, Out>]
    var function : Arc<(In)-> Out, (In)-> Out>?
    
    var enabled = true
    
    init(transitionGuard: @escaping ([Any]) -> Bool, arcsIn: [Arc<In, In>], arcsOut: [Arc<Any, Out>], function: Arc<(In)-> Out, (In)-> Out>? = nil) {
        self.transitionGuard    = transitionGuard
        self.arcsIn             = arcsIn
        self.arcsOut            = arcsOut
        
        self.function = function
    }
    
    
    public mutating func fire() -> Bool{
        if !enabled{ return false }
        
        // marking from place, executed by the labels
        var executedTokenVariable = [In]()
        var executedTokenFunction = [(In)-> Out]()
        var executedToken         = [Any]() // labels needs any
        
        for var i in arcsIn{
            
            if let inMark = i.execute(){ // Assume type not changed (In == Out), as arc is way in. see line 15
                print("Treating \(i.name) , \(inMark):")
                
                executedTokenVariable.append(inMark)
            } else {
                print("One label returned nil, " + i.name)
                resetStateVariable(tokens: executedTokenVariable)
                return false
            }
        }
        
        if var arcFun = self.function{
            if let funcToken = arcFun.execute(){
                executedTokenFunction.append(funcToken)
            } else {
                print("The label for \(arcFun.name) returned nil.")
            }
        }
        
        executedToken = executedTokenVariable + executedTokenFunction
        // ----------------------------- Check guards
        
        // Guard did not validate, return token to state.
        if !transitionGuard(executedToken) {
            self.resetStateVariable(tokens: executedTokenVariable)
            if !executedTokenFunction.isEmpty{
                resetStateFunction(token: executedTokenFunction)
            }
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
    private mutating func resetStateVariable(tokens: [In]) -> Void{
        print("Guard fails, refill value")
        for i in 0 ..< tokens.count{ // tokens count because it can be parially executed
            arcsIn[i].connectedPlaceIn!.add(token: tokens[i])
        }
    }
    // but back function token in the place
    private mutating func resetStateFunction(token: [(In)-> Out]){
        function!.connectedPlaceIn!.add(token: token[0]) // we handle only 1 function for now
    }
}
