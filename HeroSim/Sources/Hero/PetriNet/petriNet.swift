//
//  petriNet.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 08.08.19.
//

import Foundation
import Interpreter


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
    
    
    // load the json file: Definition of our network
    public func loadDefinitionFile(path: String, labelExecution:@escaping ([String : String], String) -> String?){
        let defFile = PetriNet.readFile(fileName: path)
        let data = Data(defFile.utf8)
        print("_____________________________")
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // read places
                
                if let jPlaces = json["places"] as? [String: [String:Any]]{
                    for p in jPlaces{
                        self.places[p.key] = Place(json: p.value)
                    }
                }else{
                    print("📕 No places found")
                }
                
                if let jTrans = json["transitions"] as? [String: [String: [String: Any]]]{
                    for p in jTrans {
                        self.transitions[p.key] = Transition(json: p.value, places: self.places, labelExecution: labelExecution)
                    }
                }else{
                    print("📕 No transitions found")
                }
                
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
    }
    
    public static func readFile(fileName: String) -> String{
        do {
            let contents = try NSString(contentsOfFile: fileName, encoding: 4)
            return contents as String
        } catch {
            // contents could not be loaded
            print("Error info: \(error)")
            return "not loaded"
        }
    }
    
    
    // To delete on prod & in test functions
    func definitionTest(labelExecution: @escaping ([String : String], String) -> String?){
        let dr = labelExecution
        
        let int = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 0, codomainSet: "")
        let f   = Domain(domainCardinality: 1, domainSet: "Int", codomainCardinality: 1, codomainSet: "Int")
        
        let p1 = Place(tokens: ["1", "2", "3", "4"], domain: int, name: "p1")
        let p2 = Place(tokens: ["add","sub"], domain: f, name: "p2")
        let p3 = Place(tokens: ["10"], domain: int, name: "p3")
        let places = [p1,p2,p3]
        
        let a1 = ArcIn(label: "a, b", connectedPlace: p1, name: "a1"); print(a1)
        let r1 = ArcOut(label: [{ $0["a"] }, { $0["b"] }], connectedPlace: p1, name: "r4")
        
        let a2 = ArcIn(label: "c", connectedPlace: p2, name: "a2")
        let r2 = ArcOut(label: [{ $0["c"] }], connectedPlace: p2, name: "r2")
        
        let lab3 = "operationNoCurry(a: $a$, b: $b$ , op: $c$)"
        let a3 = ArcOut(label: [{d in dr(d,lab3)}], connectedPlace: p3, name: "a2"); print(a3)
        
        let t1 = Transition(transitionGuard: [LabelTools.noGuardPrint], arcsIn: [a1,a2], arcsOut: [a3, r1, r2], name: "t1")
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
    
    func randomRun(count: Int = 1) -> Bool{
        for _ in 0..<count{
            var t = transitions.values.randomElement()
            if let res = t?.fire(){ if !res {return false}
            }else {print("!!No transition to run!!");return false}
            
        }
        return true
    }
    func manualRun(transitionName : String, binding: [String:String]){
        _ = transitions[transitionName]?.fire(manualToken: binding)
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
        print(places["p2"]!)
        print(places["p3"] ?? "Place p3 does not exist")
    }
    
    func marking(){
        print("________________________________________________________")
        print("-- Marking mode : ")
        
        // store markings
        var markings = [[[String]]]() // list of epoch of place of value
        markings.append(rendermarking())
        
        // compute all combination :
        var nonstop = 100
        while nonstop > 0{
            for t in transitions{
                
                //_ = t.value.fireForMarking() // does not delete values
                markings.append(rendermarking())
                
                
                
    //            for a in t.value.arcsIn{
    //                let bindings = a.bindName
    //                let tokens   = a.connectedPlace.tokens.getAsArray()
    //
    //                // perform all binding for a specific arc
    //                for i in 0..<tokens.count{
    //
    //                }
    //
    //
            }
            
            // compare all places
            
            if(markings[markings.endIndex-1] == markings[markings.endIndex-2]){
                nonstop -= 1
                print("markings : ")
                print(markings.last!)
            }
            
        }
        
        
    }
    
    private func rendermarking() -> [[String]]{
        var ret = [[String]]()
        for p in places{
            var token = Array(Set(p.value.tokens.getAsArray()))
            token.sort()
            ret.append(token) // need to sort to compare
        }
        return ret
    }
    
}
