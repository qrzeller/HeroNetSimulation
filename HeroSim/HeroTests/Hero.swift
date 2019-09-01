//
//  Hero.swift
//  Alpinetest1
//
//  Created by Quentin Zeller on 27.08.19.
//

import XCTest
import Interpreter

class Hero: XCTestCase {
    var interpreter = Interpreter()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let path = "/tmp/hero/curry.alpine"
        let module = PetriNet.readFile(fileName: path)
        try! interpreter.loadModule(fromString: module)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let p = PetriNet()
        
    }
    
    func testAlpineCalc(){
        
        let labelExecution = {d, l in LabelTools.dynamicReplace(t: d, label: l, interpreter: self.interpreter)}
        let pn = definitionTest(labelExecution: labelExecution)
        XCTAssertEqual(true, pn.randomRun())

    }

    func testJsonParse(){
        let fileDef  = "/tmp/hero/hnet.json"
        let p = PetriNet()
        let labelExecution = {d, l in LabelTools.dynamicReplace(t: d, label: l, interpreter: self.interpreter)}
        p.loadDefinitionFile(path: fileDef, labelExecution: labelExecution)
        XCTAssertEqual(true,p.transitions["t1"]?.fire())
    }
    
    // not multiple transition here (manually checked)
    func testSimpleMarking(){
        let fileDef  = "/tmp/hero/hnet_markingTest.json"
        let p = PetriNet()
        let labelExecution = {d, l in LabelTools.dynamicReplace(t: d, label: l, interpreter: self.interpreter)}
        p.loadDefinitionFile(path: fileDef, labelExecution: labelExecution)
        let allMarking = p.marking()
        XCTAssertEqual(5, allMarking.count)
    }

    private func definitionTest(labelExecution: @escaping ([String : String], String) -> String?) -> PetriNet{
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

        var dplaces = [String:Place<String>]()
        var dtransitions = [String:Transition<String,String>]()

        for p in places{
            assert(dplaces[p.name] == nil, "📕 The places name must be unique !")
            dplaces[p.name] = p
        }
        for t in transitions{
            assert(dtransitions[t.name] == nil, "📕 The transition name must be unique !")
            dtransitions[t.name] = t
        }

        return PetriNet(places: places, transitions: transitions, commonName: "testHero", type: PetriNet.netType.hero)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
