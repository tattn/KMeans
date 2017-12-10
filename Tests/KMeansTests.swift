//
//  KMeansTests.swift
//  KMeansTests
//
//  Created by Tatsuya Tanaka on 20171207.
//  Copyright © 2017年 tattn. All rights reserved.
//

import XCTest
@testable import KMeans

struct Vector3: KMeansElement {
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

class KMeansTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        var random: Float { return Float(arc4random()) / Float(UINT32_MAX) }
        let vectors = (1...100).map { _ in Vector3(x: random, y: random, z: random) }
        self.measure {
            let kMean = KMeans(elements: vectors, numberOfCentroids: 5, maxIteration: 300, convergeDistance: 0.001)
            print(kMean.centroids)
        }
    }
    
}
