//
//  labelTools.swift
//  AST
//
//  Created by Quentin Zeller on 23.08.19.
//

import Foundation
import Interpreter

// some function / closure to use for the labels of arcs
struct LabelTools{
    
    // replace dynamically the opération
    public static func dynamicReplace(t: [String: String], label: String, interpreter: Interpreter) -> String? {
        var lab = label
        var searchRg:Range<String.Index> = lab.startIndex..<lab.endIndex
        while let idx = lab.range(of: "[$].*?[$]", options: .regularExpression, range: searchRg) {
            let rep = lab[lab.index(after: idx.lowerBound)..<lab.index(before: idx.upperBound)]
            lab.replaceSubrange(idx, with: t[String(rep)]!)
            searchRg = idx.lowerBound..<lab.endIndex
            
        }
        let value = try! interpreter.eval(string: lab)
        return value.description
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
