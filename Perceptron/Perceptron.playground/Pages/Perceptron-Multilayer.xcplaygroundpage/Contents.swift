//: Playground - noun: a place where people can play
import UIKit
import PlaygroundSupport

struct Pattern {
	let input: [Double]
	let label: [Double] // 3 values
	
	init(input: [Double], label: [Double]) {
		self.input = input
		self.label = label
	}
}

func predict(_ input: [Double], _ w: [[Double]]) -> [Double] {
	var u: [Double] = [0, 0, 0]
	
	for j in 0..<3 {
		var aux = 0.0
		for i in 0..<input.count {
			aux += input[i] * w[j][i]
		}
		u[j] = aux > 0.0 ? 1.0 : 0.0
	}
	
	return u
}

func train(dataArr: [Pattern], learningRate: Double, epochsNumber: Int) -> [[Double]]{
	var w: [[Double]] = [[], [], []]
	
	for _ in 0..<dataArr[0].input.count {
		w[0].append(Double.random(in: -1.0...1.0))
		w[1].append(Double.random(in: -1.0...1.0))
		w[2].append(Double.random(in: -1.0...1.0))
	}
	
	for _ in 0..<epochsNumber {
		//var errors = 0
		
		for data in dataArr {
			let y = predict(data.input, w)
			
			for j in 0..<3 {
				let e = y[j] - data.label[j]
				
				for i in 0..<data.input.count {
					//wji(t) = wji(t-1) + learningRate * ej * xi
					w[j][i] = w[j][i] + learningRate * e * data.input[i]
				}
			}
			
//			let y = predict(data.input, w)
//
//			if data.label != y {
//				errors += 1
//
//				let error = data.label - y
//				for i in 0..<w.count {
//					w[i] += learningRate * error * data.input[i]
//				}
//
//			}
		}
		
		//if errors == 0 { return w }
	}
	
	return w
}


let dataArr = [Pattern(input: [1.0, 0.0], label: [1.0, 0.0, 0.0]),
			   Pattern(input: [0.0, 0.0], label: [0.0, 1.0, 0.0]),
			   Pattern(input: [0.1, 1.0], label: [1.0, 0.0, 0.0]),
			   Pattern(input: [1.0, 1.0], label: [1.0, 0.0, 0.0])]

let weights = train(dataArr: dataArr, learningRate: 0.1, epochsNumber: 40)


predict([0, 0], weights)
predict([0, 1], weights)
predict([1, 0], weights)
predict([1, 1], weights)




//
//	let input = [2,4,5]
//	let wOld = [[0, 1, 2], [0,2,3], [1,3,4]]
//	let wNew = []
//	for perceptronWeights in wOld {
//
//		for weight in perceptronWeights {
//
//		}
//	}

/*

u = wTx

em teoria é como se o vetor de entrada fosse apresentado ao mesmo tempo nos 3 neurônios

rede com c neuronios onde c é o número de classes para o problema
cada neuronio tem o seu vetor de pesos
for para o numero de neuronios, for para o numero de entradas
cada neuronio tem um erro diferente

wji(t) = wji(t-1) + learningRate * ej * xi

*/
