
import Interpreter
import Foundation

func test2(){
    let root = "/Users/quentinzeller/Github/OFA/Alpine-tests/Alpine-test1/Sources/Alpine-test1/"

    //let interpreter = Interpreter()
    //let value = try! interpreter.eval(string: "42")
    //
    //print(value)


    // autre test

    func read(fileName: String) -> String{
        do {
            let contents = try NSString(contentsOfFile: fileName, encoding: 4)
            return contents as String
        } catch {
            // contents could not be loaded
            print("Error info: \(error)")
            return "not loaded"
        }
        
    }

    var module: String = read(fileName: root+"curry.alpine")

    let expressionFunc: Set = ["add", "sub", "div", "mul"]
    let expressionNumber: Set = [-1, 1,2,3,4,5,6]

    var eF = expressionFunc
    var eN = expressionNumber


    var interpreter2 = Interpreter()
    try! interpreter2.loadModule(fromString: module)

    // TODO check emptiness
    let fun = eF.popFirst() ?? "empty"
    let n1  = eN.popFirst()!
    let n2  = eN.popFirst()!

    //let code: String = fun + "(\(n1), \(n2))"
    let code: String = "operationNoCurry(\(n1), \(n2) , op: \(fun))"
    print(code)
    let value2 = try! interpreter2.eval(string: code)
    print(value2)

    // With curry
    let code2: String = "operationCurry(\(n1), op: \(fun))"
    print(code2)
    let value3 = try! interpreter2.eval(string: code2)

    print(value3)
    //// ...???





    //TODO enregistrer automatiquement dans des strucutures.
    print(" ------- ")
    //let str = "{\"names\": [\"Bob\", \"Tim\", \"Tina\"]}"
    let str = read(fileName: root + "hnet.json")
    let data = Data(str.utf8)

    do {
        // make sure this JSON is in the format we expect
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            // read places
            
            var place1: String = "";
            var place2: String = "";
            var arc3Exec: String = "";
            
            if let transitions = json["transitions"] as? [String: [String: [String: Any]]] {
                //print("Transitions : " , transitions)
                
                
                let arc = transitions["t1"]!["arcs"]! as? [String: [String:String]]
                print(arc!)
                
                // Set of all arc in
                place1 = arc!["a1"]!["in"]!
                place2 = arc!["a2"]!["in"]!
                
                // Make set of all arcs out TODO
                arc3Exec = arc!["a3"]!["exec"]!
                
                
            }
            print(" ")
            if let places = json["places"] as? [String: [String: Any]] {
                print("Places : " , places)
                
                // replace by for loop with case on "func"
                
                // if func :
                let file: String
                if (places[place1]!["isRef"]! as? Bool)!{
                    let ref = places[place1]!["data"]! as! String
                    file = read(fileName: root + ref)
                    
                    
                    
                    
                }else{
                    // load string directly
                    file = ""
                    exit(1)
                }
                
                
                // load the numbers
                var shuffledZ : [Int] = []
                if (places[place2]!["type"]! as! String == "Z"){
                    print("Generating Z...???")
                    let sequence = 0 ... 8
                    shuffledZ = sequence.shuffled()
                    
                    
                    
                }else{
                    // load string directly
                    exit(1)
                }
                
                
                // load module file to alpine
                // to move global
                var interp = Interpreter()
                try! interp.loadModule(fromString: file)
                
                ////
                let a = shuffledZ.popLast()!
                let b = shuffledZ.popLast()!
                
                var expFun: Set = ["add", "sub", "div", "mul"]
                let fun = expFun.popFirst() ?? "empty"
                
                print("\n ||||||||||||||||||||||||| \n\n")
                let code: String = "\(arc3Exec)(\(a), \(b) , op: \(fun))"
                print("Running : ", code)
                let value2 = try! interp.eval(string: code)
                print("Result  = ", value2)
            }
            
            // manual exec calculatrix
            
            
            
            
            
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}
