
//
//  File.swift
//  Alpine-test1
//
//  Created by Quentin Zeller on 06.08.19.
//

import Foundation
import Interpreter
let filePath = "/tmp/hero/curry.alpine"
let fileDef  = "/tmp/hero/hnet.json"


print("__________________ HeroN ____________________")

var interpreter = Interpreter()
let module = PetriNet.readFile(fileName: filePath)
try! interpreter.loadModule(fromString: module)
let labelExecution = {d, l in LabelTools.dynamicReplace(t: d, label: l, interpreter: interpreter)}



let p = PetriNet()
p.loadDefinitionFile(path: fileDef, labelExecution: labelExecution)
p.manualRun(transitionName: "t1", binding: ["a":"1","c":"sub"])
print(p.transitions["t1"]!.arcsIn[0])
//p.randomRun()
//p.transitions["t2"]?.fire()


//let allMarking = p.marking()
//
//print("________________________________________________")
//
//for i in allMarking{
//    print("🔷", i.sorted(by: { $0.0 < $1.0 }))}
//print("🔷🔷🔷 All different marking : ", allMarking.count)
