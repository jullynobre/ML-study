typealias DataType = [[Double]]
import PlaygroundSupport
import UIKit

class DMC {
    
    private var centroids = [Double: [Double]]()
    private var input = DataType()
    private var minElements = [Double]()
    private var maxElements = [Double]()

    init(withInput input : DataType) {
        
        self.input = input
    }

    func train() {
        
        var categories = Set<Double>()
        
        //        Exemplo de input:
        //        let input = [[1.7, 80, 0],
        //                     [1.8, 75, 0],
        //                     [0.6, 220, 1],
        //                     [0.5, 170, 1]]
        
        // {category0 : 2, category1: 2}
        var numberOfElements = [Double : Int]()
        var sumOfElements = [Double: [Double]]()
        self.minElements = Array(repeating: Double.greatestFiniteMagnitude, count: input.count - 1)
        self.maxElements = Array(repeating: -Double.greatestFiniteMagnitude, count: input.count - 1)
        
        // Exemplo de entrada de dados
        // [1.7, 95, 1]
        for data in input {
            
            // [1.7, 95]
            var x = data
            // 1
            let y = x.removeLast()
            
            categories.insert(y)
            
            numberOfElements[y] = numberOfElements.keys.contains(y) ? numberOfElements[y]! + 1 : 1
            
            // [1.7, 95] + [1.8, 105]
            sumOfElements[y] = sumOfElements.keys.contains(y) ? zip(sumOfElements[y]!, x).map({ $0 + $1 }) : x
            
            for (index, value) in x.enumerated() {
                
                let minElementAtIndex = minElements[index]
                let maxElementAtIndex = maxElements[index]
                
                if value < minElementAtIndex {
                    
                    minElements[index] = value
                }
                
                if value > maxElementAtIndex {
                    
                    maxElements[index] = value
                }
            }
        }
        
        for key in sumOfElements.keys {
            
            var averageValue = [Double]()
            
            for data in sumOfElements[key]! {
                
                averageValue.append(data / Double(numberOfElements[key]!))
                sumOfElements[key] = averageValue
            }
        }
        
        // Centroides normalizados
        centroids = normalize(sumOfElements)
        
        // Centroids não normalizados
//        centroids = sumOfElements
    }
    
    func normalize(_ centroids : [Double : [Double]]) -> [Double : [Double]] {
        
        var normalizedCentroids = [Double : [Double]]()
        
        for (key, values) in centroids {
            
            var normalized = [Double]()
            
            for (index, value) in values.enumerated() {
                
                normalized.append(self.normalize(value, lowerValue: self.minElements[index], andHigher: self.maxElements[index]))
                normalized.append(value)

            }
            
            normalizedCentroids[key] = normalized
        }
        
        return normalizedCentroids
    }
    
    func normalize(_ value : Double, lowerValue lower : Double, andHigher higher : Double) -> Double {
        
        return (value - lower) / (higher - lower)
    }
    
    func predict(withInput input : [Double]) -> Double {

        var closestIndex : Double = 0
        var closestDistance = Double.greatestFiniteMagnitude

        for key in self.centroids.keys {
            
            var sumOfDistances : Double = 0
            let centroidData = self.centroids[key]!
            
            for (index, data) in input.enumerated() {
                
                let normalizedCentroid = centroidData[index]
                // Distâncias normalizadas
//                let normalizedInput = self.normalize(data, lowerValue: minElements[index], andHigher: maxElements[index])
                
                // Distâncias não-normalizadas
                let normalizedInput = data

//                sumOfDistances += Double(abs(data - centroidData[index]))
                
                sumOfDistances += Double(abs(normalizedInput - normalizedCentroid))
            }
            
            if sumOfDistances < closestDistance {
                
                closestDistance = sumOfDistances
                closestIndex = key
            }
        }
        
        return closestIndex
    }
}


// Temos no input respectivamente Altura em metros e peso em quilos de humanos e porcos
// 0 representa humano
// 1 representa porco

// Dataset
let input = [[1.7, 80, 0],
             [1.8, 75, 0],
             [0.6, 220, 1],
             [0.5, 170, 1]]

let dmc = DMC(withInput: input)

// Função de treinamento
dmc.train()

// Função de predição
dmc.predict(withInput: [0, 83])
