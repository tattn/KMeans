KMeans
===

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Version](https://img.shields.io/badge/Swift-4-F16D39.svg)](https://developer.apple.com/swift)


```swift
import KMeans

struct Vector3: KMeansVector {
    let x, y, z: Float

    static var zeroValue: Vector3 { return .init(x: 0, y: 0, z: 0) }

    func squareDistance(to vector: Vector3) -> Float {
        return pow(x - vector.x, 2) + pow(y - vector.y, 2) + pow(z - vector.z, 2)
    }

    static func +(left: Vector3, right: Vector3) -> Vector3 {
        return .init(x: left.x + right.x,
                     y: left.y + right.y,
                     z: left.z + right.z)
    }

    static func /(left: Vector3, right: Int) -> Vector3 {
        return .init(x: left.x / Float(right),
                     y: left.y / Float(right),
                     z: left.z / Float(right))
    }
}

var random: Float { return Float(arc4random()) / Float(UINT32_MAX) }
let vectors = (1...100).map { _ in Vector3(x: random, y: random, z: random) }

let kMean = KMeans(elements: vectors, numberOfCentroids: 5, maxIteration: 300, convergeDistance: 0.001)
print(kMean.centroids)
```

## 

# Installation

## Carthage

```ruby
github "tattn/KMeans"
```


# Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# License

KMeans is released under the MIT license. See LICENSE for details.
