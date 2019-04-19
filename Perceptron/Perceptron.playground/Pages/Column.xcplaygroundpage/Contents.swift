import PlaygroundSupport
import Foundation

struct Pattern {
	let input: [Double]
	let label: [Double] // 3 classes
	
	init(input: [Double], label: [Double]) {
		self.input = input
		self.label = label
	}
}

func predict(_ input: [Double], _ w: [[Double]]) -> [Double] {
	var u: [Double] = [0, 0, 0]
	var uArr: [Double] = [0, 0, 0]
	
	for j in 0..<3 {
		var aux = 0.0
		for i in 0..<input.count {
			aux += input[i] * w[j][i]
		}
		uArr[j] = aux
		u[j] = aux > 0.0 ? 1.0 : 0.0
	}
	
	let sum = u[0] + u[1] + u[2]
	if sum != 1.0 {
		let bigger = uArr.max()
		
		for i in 0..<u.count {
			u[i] = uArr[i] != bigger ? 0.0 : 1.0
		}
	}
	
	return u
}

func train(dataArr: [Pattern], learningRate: Double, epochsNumber: Int) -> [[Double]]{
	var w: [[Double]] = [[], [], []]
	
	for _ in 0..<dataArr[0].input.count {
		w[0].append(Double.random(in: 1.4...1.6))
		w[1].append(Double.random(in: 1.4...1.6))
		w[2].append(Double.random(in: 1.4...1.6))
	}
	
	for _ in 0..<epochsNumber {
		var errors = 0
		for data in dataArr {
			let y = predict(data.input, w)
			
			for j in 0..<3 {
				let e = data.label[j] - y[j]
				
				if e != 0.0 {
					errors += 1
					for i in 0..<data.input.count {
						w[j][i] = w[j][i] + learningRate * e * data.input[i]
					}
				}
			}
		}
		if errors == 0 {
			return w
		}
	}
	
	return w
}

func test(_ testingData: [Pattern], _ weigths: [[Double]]) -> Double {
	var hit: Int = 0
	
	for testData in testingData {
		let d = testData.label
		let y = predict(testData.input, weigths)
		if d[0] == y[0] && d[1] == y[1] && d[2] == y[2] {
			hit += 1
		} else {
			print("Label: \(d) - Prediction: \(y)")
		}
		
	}
	
	return Double(hit) / Double(testingData.count)
}

let data = try Data(contentsOf: Bundle.main.url(forResource: "column_3C", withExtension: "dat")!)
let dataStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
var patternsArr = dataStr.components(separatedBy: "\n")
patternsArr.remove(at: 310)

var dataArr: [Pattern] = []

for pattern in patternsArr {
	let patternSplt = pattern.components(separatedBy: " ")

	let dataInput = [Double(patternSplt[0])!,
					 Double(patternSplt[1])!,
					 Double(patternSplt[2])!,
					 Double(patternSplt[3])!,
					 Double(patternSplt[4])!,
					 Double(patternSplt[5])!]
	
	var dataLabel: [Double] = [0.0, 0.0, 0.0]

	switch patternSplt[6] {
	case "DH":
		dataLabel[0] = 1.0
		break
	case "SL":
		dataLabel[1] = 1.0
		break
	default:
		dataLabel[2] = 1.0
		break
	}
	dataArr.append(Pattern(input: dataInput, label: dataLabel))
}

var testHits = 0.0
for _ in 1...10{
	dataArr.shuffle()
	
	let trainDataArr = Array(dataArr[0..<247])
	let testDataArr = Array(dataArr[247..<310])
	
	let weights = train(dataArr: trainDataArr, learningRate: 0.1, epochsNumber: 100)
	
	let hitPercentual = test(testDataArr, weights) * 100
	testHits += hitPercentual
	print("\(hitPercentual)%\n")
}

print("\nAccurace: \(testHits/10)%")
