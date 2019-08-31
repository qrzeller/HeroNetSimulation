//
//  File.swift
//  Hero
//
//  Created by Quentin Zeller on 31.08.19.
//

import Foundation
class Combination {
    
    
    
    static func combinationUtil2(arr: [String], data: inout [String], index: Int, r: Int, result: inout [[String]]){
        
        if (index == r){result.append(data); return}
        
        for i in 0..<arr.count{ // (data.count)
            var listCp = arr
            data[index] = listCp.remove(at: i)
            combinationUtil2(arr: listCp, data: &data, index: index+1, r: r, result: &result)
        }
    }
    
    

    static func test(){
        let arr = ["a", "b", "c","d", "e", "f"]
        var result = [[String]]()
        let r = 2
        var data: [String] = Array<String>(repeating: "", count: r) // size ?
        
        combinationUtil2(arr: arr, data: &data, index: 0, r: r, result: &result)
        
        for i in result{print(i.joined())}
        print("Count: ", result.count)
        assert(result.count == Set(result).count, "There is dupplicate")
    
    }
}
