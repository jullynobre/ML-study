import Cocoa

// y = ax - b
// w0 = -b w1 = a
// y = w1x + w0

// x: value, y: label
struct DataObject {
    let x: Double
    let y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

//return w1x + w0
func predict(input: Double, weights: [Double]) -> Double {
    let y = weights[1] * input - weights[0]
    return y
}

//Returns trained WEIGHTS (a and b)
func train(dataArr: [DataObject], learningRate: Double, epochsNumber: Int) -> [Double]{
    var weights = [Double.random(in: -1.0...1.0),
                   Double.random(in: -1.0...1.0)]
    
    var epochs = 0
    
    for _ in 0...epochsNumber {
        var errors = 0
        
        for data in dataArr {
            let y = predict(input: data.x, weights: weights)
            if y != data.y {
                errors += 1
                
                let error = data.y - y

                weights[0] = weights[0] + learningRate * error * -1
                weights[1] = weights[1] + learningRate * error * data.x
            }
        }
        
        if errors == 0 {
            return weights
        }
        epochs += 1
    }
    
    return weights
}

// y = -2x + 1
let dataArr = [DataObject(x: -3, y: 7),
               DataObject(x: -2, y: 5),
               DataObject(x: -1, y: 3),
               DataObject(x: 0, y: 1),
               DataObject(x: 1, y: -1),
               DataObject(x: 2, y: -3),
               DataObject(x: 3, y: -5),
]

let weights = train(dataArr: dataArr, learningRate: 0.1, epochsNumber: 20)

predict(input: 4, weights: weights)
predict(input: 5, weights: weights)
predict(input: -15, weights: weights)

