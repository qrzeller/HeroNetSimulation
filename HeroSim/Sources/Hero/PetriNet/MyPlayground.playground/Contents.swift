import Foundation

var a: Array<Float> = Array()
a.append(10)
var b: Array<String> = Array()
b.append("10")


let x = 3

func test(a: Int) -> Void{
    print("hello \(a)")
}
let testAny: Any = test as Any

let youhyou = testAny as! (Int) -> Void

let saveCast = type(of: testAny)
//let voila   = testAny as! saveCast


// workaround
func cast<T>(value: Any, to type: T) -> T {
    return value as! T
}

let voilaOk = cast(value: testAny, to: youhyou)

voilaOk(4)

youhyou(3)
//voila(3)
let somelabel = "a,.    b"

let removed = somelabel.components(separatedBy: CharacterSet([" ", ",", "\t", "\n",])).filter { $0 != "" }
print(removed)


var di = [String: Int]()
di["hello"] = 2
di["2"] = 3

for d in di{
    print(d.value)
}
var hw = "hello worlod"
let rg = hw.range(of: "o.*o", options: .regularExpression)

hw.replaceSubrange(rg!, with: "0 W0")


var lab = "operationNoCurry(a: $a$, b: $b$, op: $c$)"

var searchRg:Range<String.Index> = lab.startIndex..<lab.endIndex
while let idx = lab.range(of: "[$].*?[$]", options: .regularExpression, range: searchRg) {
    let rep = lab[lab.index(after: idx.lowerBound)..<lab.index(before: idx.upperBound)]
    lab.replaceSubrange(idx, with: "x")
    searchRg = idx.lowerBound..<lab.endIndex
    
}

print(lab)

print("__________________")
import Interpreter
let filePath = "/Users/quentinzeller/Github/OFA/HeroNetSimulation/HeroSim/Sources/Alpine-test1/curry.alpine"
var interpreter = Interpreter()

func readFile(fileName: String) -> String{
    do {
        let contents = try NSString(contentsOfFile: fileName, encoding: 4)
        return contents as String
    } catch {
        // contents could not be loaded
        print("Error info: \(error)")
        return "not loaded"
    }
}

let module = readFile(fileName: filePath)
try! interpreter.loadModule(fromString: module)

let value = try interpreter.eval(string: "guardTwo(2)")

