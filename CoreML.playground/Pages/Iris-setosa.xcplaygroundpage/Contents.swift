import UIKit
import PlaygroundSupport

struct DataObject {
	let input: [Double]
	let label: Double
	
	init(input: [Double], label: Double) {
		self.input = input
		self.label = label
	}
}

func predict(_ input: [Double], _ w: [Double]) -> Double {
	var u: Double = 0
	
	for i in 0..<input.count {
		u += input[i] * w[i]
	}
	
	return u > 0.0 ? 1.0 : 0.0
}

func train(dataArr: [DataObject], learningRate: Double, epochsNumber: Int) -> [Double]{
	var w: [Double] = []
	
	for _ in 0..<dataArr[0].input.count {
		w.append(Double.random(in: -1.0...1.0))
	}
	
	var epochs = 0
	
	for _ in 0...epochsNumber {
		var errors = 0
		for data in dataArr {
			let y = predict(data.input, w)
			//print("\(y) - \(data.label)")
			if data.label != y {
				errors += 1
				let error = data.label - y
				
				for i in 0..<w.count {
					w[i] += learningRate * error * data.input[i]
				}
			}
		}
		
		if errors == 0 {
			break
		}
		epochs += 1
	}
	epochs
	
	return w
}

func test(_ testingData: [DataObject], _ weigths: [Double]) -> Double {
	var hit: Int = 0
	
	for testData in testingData {
		let d = testData.label
		let y = predict(testData.input, weigths)
		if d == y {
			hit += 1
		}
		print("Label: \(d) - Prediction: \(y)")
	}
	
    return Double(hit) / Double(testingData.count)
}


let data = try Data(contentsOf: Bundle.main.url(forResource: "iris", withExtension: "data")!)
let dataStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
var patternsArr = dataStr.components(separatedBy: "\n")
patternsArr.remove(at: 150)

var dataArr: [DataObject] = []
for pattern in patternsArr {
	let patternSplt = pattern.components(separatedBy: ",")
	let dataLabel = patternSplt[4] == "Iris-setosa" ? 1.0 : 0.0
	let dataInput = [Double(patternSplt[0])!,
					 Double(patternSplt[1])!,
					 Double(patternSplt[2])!,
					 Double(patternSplt[3])!]
	
	dataArr.append(DataObject(input: dataInput, label: dataLabel))
}

dataArr.shuffle()

let trainDataArr = Array(dataArr[0..<120])
let testDataArr = Array(dataArr[120..<150])

let weights = train(dataArr: trainDataArr, learningRate: 0.1, epochsNumber: 200)

print("\n\(test(testDataArr, weights) * 100)%")

