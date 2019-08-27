//
//  transition.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation

struct Transition<In: Equatable, Out: Equatable>{

    let transitionGuard: ([String: In]) -> Bool//([In]) -> Bool
    
    var arcsIn  :[ArcIn<In>] // TODO only binding
    var arcsOut :[ArcOut<In, Out>]
    
    var enabled = true
    let existingBindings: [String]
    
    let name: String
    
    init(transitionGuard: @escaping ([String: In]) -> Bool, arcsIn: [ArcIn<In>], arcsOut: [ArcOut<In, Out>], name:String) {
        self.transitionGuard    = transitionGuard
        self.arcsIn             = arcsIn
        self.arcsOut            = arcsOut
        self.name               = name
        
        // store existing bindings (used for manual fire: public mutating func fire(executedToken : [String:In]) -> Bool)
        self.existingBindings = Transition<In, Out>.computebinding(arcsIn: arcsIn)
    }

    // For json serialisation, work only with String type. Thus we assume In==Out==String
    init?(json: [String: [String: Any]], places : [String: Place<In>], labelExecution:@escaping ([String : In], String) -> (Out?) ){
        
        assert(In.self == String.self && String.self == Out.self, "This initialiser assume types are String")
        
        arcsIn = [ArcIn<In>]()
        arcsOut = [ArcOut<In,Out>]()
        
        if let arcs = json["arcs"]{
            if let ais = arcs["in"] as? [String: [String: Any]]{
                for ai in ais{ // load arcs in from file
                    arcsIn.append(ArcIn(label: ai.value["label"] as! String, connectedPlace: places[ai.value["connectedPlace"] as! String]! , name: ai.value["name"] as! String))
                }
            } else {print("📕 No arcIn found."); return nil}
            
            if let aos = arcs["out"] as? [String: [String: Any]]{
                for ao in aos{ // load arc out from file
                    arcsOut.append(ArcOut(label: [{d in labelExecution(d, ao.value["label"] as! String)}],
                                          connectedPlace: places[ao.value["connectedPlace"] as! String] as! Place<Out> ,
                                          name: ao.value["name"] as! String))
                }
            } else {print("📕 No arcOut found."); return nil}
            
        }else{print("📕 No arcs found"); return nil}
        
        if let codeGuard = json["guards"]?["code"] as? String{
            transitionGuard = {(d: [String: In]) -> Bool in LabelTools.asBool(output: labelExecution(d, codeGuard) as! String?)}
        } else {
            print("📙 No proper guard found, assume no guard")
            transitionGuard = {d in return true}
        }
        self.existingBindings = Transition<In, Out>.computebinding(arcsIn: arcsIn)
        if let name = json["meta"]?["name"] as? String {
            self.name = name
        }else{
            print("📕 The name is not defined, and required in the class petriNet")
            return nil
        }
        
    }
    
    // compute all bindings entry, used only in *init()*
    private static func computebinding(arcsIn: [ArcIn<In>]) -> [String]{
        var bindings = [String]()
        for a in arcsIn {
            bindings.append(contentsOf: a.bindName)
        }
        return bindings
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
                    print("📙 One binding could not be performed, Arc:\(i.name), \(inMark), probably no more token")
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
            print("📙 The guard fail")
            self.resetState(tokens: executedToken)
            return false
        }
        
        // _______________ Execute out arcs _____________________________
        
        for var i in arcsOut{
            let outMark = i.execute(transitionParams: executedToken)
                print("📗 The execution \(i.name) returned: \(outMark) ")
           
        }
        
        return true // improove
    }
    
    // Fire with pre defined tokens (manual fire)
    public mutating func fire(manualToken : [String: In]) -> Bool{
        if !enabled{ return false }
        if manualToken.count != existingBindings.count {
            print("📕 The size of the dictionnary must match the count of the bindings.")
            return false
        }
        // Check if tokens exists
        var executedToken         = [String: In]()
        for token in manualToken{
            // check is biniding exist, (overkill since next section is sufficient but usefull for debug)
            if(!existingBindings.contains(token.key)){
                print("📕 The binding \"\(token.key)\" does not exist.")
                print("\t\tAvailable binding : \(existingBindings)")
                return false
            }
            // check if value is in places
            for a in arcsIn{
                if a.bindName.contains(token.key) {
                    if let deleted = a.connectedPlace.tokens.del(value: token.value){
                        executedToken[token.key] = deleted // same as = token.value
                        break // does not need to search further...
                    }else{
                        print("📕 Token \(token) does not exist")
                        self.resetState(tokens: executedToken)
                        return false
                    }
                }
            }
        }
        
        // ---------------- Check guards -------------------------------
        // If guard did not validate, return token to state.
        if !transitionGuard(executedToken) {
            print("📙 The guard fail")
            self.resetState(tokens: executedToken)
            return false
        }
        
        // _______________ Execute out arcs _____________________________
        
        for var i in arcsOut{
            let outMark = i.execute(transitionParams: executedToken)
                print("📗 The execution \(i.name) returned: \(outMark) ")
          
        }
        
        return true // improove
    }

    
    // Fire without removing values, adding value output
    public func fireForMarking() -> Bool{
        if !enabled{ return false }
        
        // marking from place, executed by the labels
        var executedToken         = [String: In]()
        for var i in arcsIn{
            let inMarks = i.execute(delete: false)
            for inMark in inMarks{
                if inMark.value != nil{
                    executedToken[inMark.key] = inMark.value
                } else { // probably mean that we have not enough token in our place
                    print("📙 One binding could not be performed, Arc:\(i.name), \(inMark), probably no more token")
                }
            }
        }
        
        // ---------------- Check guards -------------------------------
        // If guard did not validate, return token to state.
        if !transitionGuard(executedToken) {
            print("📙 The guard fail")
            return false
        }
        
        // _______________ Execute out arcs _____________________________
        
        for var i in arcsOut{
            let outMark = i.execute(transitionParams: executedToken)
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
        print("📙 Refill values: \(tokens)")
        
        for i in tokens{
            for var arc in arcsIn{
                if( arc.bindName.contains(where: {$0 == i.key})){ // if the mapping belong to this arc
                    arc.connectedPlace.add(token: i.value) // add the token to the connected place
                    print("\t\tToken \(i.value) put back to arc \(arc.name)")
                }
            }
        }
    }
}
