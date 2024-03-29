//: Playground - noun: a place where people can play
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

// Aqui devemos computar a taxa de acertos para a base de teste
//func test(_ testingData: [Data], _ weigths: [Double]) -> Double {
//
//    return 0.0
//}

let dataArr = [DataObject(input: [0.96, 0.0], label: 1.0),
			   DataObject(input: [0.05, 0.1], label: 0.0),
			   DataObject(input: [0.1, 0.9], label: 1.0),
			   DataObject(input: [0.89, 1.0], label: 1.0)]

let weights = train(dataArr: dataArr, learningRate: 0.1, epochsNumber: 20)

predict([0, 0], weights)
predict([0, 1], weights)
predict([1, 0], weights)
predict([1, 1], weights)


