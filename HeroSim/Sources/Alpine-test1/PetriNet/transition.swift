//
//  transition.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Transition{
    
    // TODO
    let transitionGuard: ([Any]) -> Bool
    
    let arcsIn :[Arc<Any>]
    let arcsOut :[Arc<Any>]
    
    // TODO, in case we need to store what is it
    let description: Any?
    
    var enabled = true
    
    init(transitionGuard: @escaping ([Any]) -> Bool, description: Any? = nil, arcsIn: [Arc<Any>], arcsOut: [Arc<Any>]) {
        self.transitionGuard    = transitionGuard
        self.description        = description
        self.arcsIn             = arcsIn
        self.arcsOut            = arcsOut
    }
    
    
    public func fire() -> Bool{
        if !enabled{ return false }
        
        // marking from place, executed by the labels
        var executedToken = [Any]()
        for var i in arcsIn{
            
            if let inMark = i.execute(){
                print("Treating \(i.name) , \(inMark):")
                
                executedToken.append(inMark)
            } else {
                print("One label returned nil, " + i.name)
                return false
            }
        }
        // run token between them. -----
        // Normally the job of the out label :
        let fun = executedToken[1]  as! (Int) -> Int
        print("-----> Executed :", fun(executedToken[0] as! Int))
        
        // -----------------------------
        
        
        // TODO : we need to choose a subset of the variable. The in parameter are not everything for sure !!!!
        
        for var i in arcsOut{
            if let outMark = i.execute(paramsOut: executedToken){
                i.connectedPlace.add(token: outMark)
            } else {
                print("The execution returned nil, " + i.name)
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
