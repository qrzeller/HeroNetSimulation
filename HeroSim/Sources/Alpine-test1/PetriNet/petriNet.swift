//
//  petriNet.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation



class PetriNet{
    enum netType{
        case hero
    }
    
    let type : netType
    let commonName: String
    var places = [String: Place<String>]()
    var transitions = [String: Transition<String, String>]()

    init(places: [Place<String>] = [Place<String>](),transitions: [Transition<String, String>] = [Transition<String, String>]() , commonName: String = "" ,type: netType = .hero) {
        self.type = type
        self.commonName = commonName
        
        // Init places and transition object.§
        for p in places{
            assert(self.places[p.name] == nil, "📕 The places name must be unique !")
            self.places[p.name] = p
        }
        for t in transitions{
            assert(self.transitions[t.name] == nil, "📕 The transition name must be unique !")
            self.transitions[t.name] = t
        }
    }
    
    func definitionTest(){
        let int = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 0, codomainSet: "")
        let f   = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 1, codomainSet: "Int")
        
        let p1 = Place(tokens: ["1", "2", "3"], domain: int, name: "p1")
        let p2 = Place(tokens: ["add","sub"], domain: f, name: "p2")
        let p3 = Place(tokens: ["10"], domain: int, name: "p3")
        let places = [p1,p2,p3]
        
        let a1 = ArcIn(label: "a, b", connectedPlace: p1, name: "a1"); print(a1)
        let a2 = ArcIn(label: "c", connectedPlace: p2, name: "a2")
        let a3 = ArcOut(label: PetriNet.opNoCurry, connectedPlace: p3, name: "a2"); print(a3)
        
        let t1 = Transition(transitionGuard: PetriNet.noGuardPrint, arcsIn: [a1,a2], arcsOut: [a3], name: "t1")
        let transitions = [t1]
        
        for p in places{
            assert(self.places[p.name] == nil, "📕 The places name must be unique !")
            self.places[p.name] = p
        }
        for t in transitions{
            assert(self.transitions[t.name] == nil, "📕 The transition name must be unique !")
            self.transitions[t.name] = t
        }
        
    }
    
    func startDefinitionTest(){
        print("----------- Test run -----------")
        for var t in transitions{
            print("Run transition : \(t.value.name) ➡")
            _ = t.value.fire(manualToken: [
                "a":"2",
                "b":"3",
                "c":"sub"
                ])
        }
        print("Random fire : ➡")
        _ = transitions["t1"]?.fire()
        print(places["p1"]!)
        print(places["p3"] ?? "Place p3 does not exist")
    }
    
    func marking(){
        print("________________________________________________________")
        print("-- Marking mode : ")
    }
    
    
    // Basic function, example function if you want to personalise the labels execution
    public static let opNoCurry = { (t: [String: String]) -> String? in
        let code: String = "operationNoCurry(a: \(t["a"]!), b: \(t["b"]!) , op: \(t["c"]!))"
        let value = try! interpreter.eval(string: code)
        return value.description
    }
    
    public static let noGuardPrint = { (a: [String: String]) -> Bool in
        print("Guarded : \(a).")
        return true
    }
    
}
