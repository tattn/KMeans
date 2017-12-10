//
//  KMenas.swift
//  KMeans
//
//  Created by Tatsuya Tanaka on 20171207.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

public protocol KMeansElement {
    static var zeroValue: Self { get }

    static func + (left: Self, right: Self) -> Self
    static func / (left: Self, right: Int) -> Self

    func squareDistance(to: Self) -> Float
}

public struct KMeans<T: KMeansElement> {
    public static var defaultMaxIteration: Int { return 300 }

    public let numberOfCentroids: Int
    public let maxIteration: Int
    public let convergeDistance: Float?

    private(set) var centroids: [T]!

    public init(elements: [T],
                numberOfCentroids: Int,
                maxIteration: Int = defaultMaxIteration,
                convergeDistance: Float? = nil) {
        assert(numberOfCentroids > 1, "k-means (k > 1)")
        assert(maxIteration >= 0, "maxIteration >= 0)")
        self.numberOfCentroids = numberOfCentroids
        self.maxIteration = maxIteration
        self.convergeDistance = convergeDistance

        centroids = fitPredict(elements: elements)
    }

    private func fitPredict(elements: [T]) -> [T] {
        guard !elements.isEmpty else { return [] }

        let convergeSquareDistance = convergeDistance.map { $0 * $0 }
        let zero = T.zeroValue
        var centroids = elements.randomElements(numberOfCentroids)

        for _ in 0..<maxIteration {
            var classification: [[T]] = .init(repeating: [], count: numberOfCentroids)

            // find k centroids
            for element in elements {
                let classIndex = index(of: element, in: centroids)
                classification[classIndex].append(element)
            }

            // calculate the average of the centroids
            let newCentroids: [T] = classification.map { elements in
                let count = elements.count
                if count > 0 {
                    return elements.reduce(zero, +) / count
                } else {
                    return zero
                }
            }

            // calculate the distance from the last centroid position
            var centerMoveSquareDistance: Float = 0.0
            for index in 0..<numberOfCentroids {
                centerMoveSquareDistance += centroids[index].squareDistance(to: newCentroids[index])
            }

            centroids = newCentroids

            if let converge = convergeSquareDistance,
                centerMoveSquareDistance <= converge { break }
        }

        return centroids
    }

    public func getCentroid(of element: T) -> T {
        let index = self.index(of: element, in: centroids)
        return centroids[index]
    }

    private func index(of element: T, in centroids: [T]) -> Int {
        var nearestDistance = Float.greatestFiniteMagnitude
        var minIndex = 0

        for (index, centroid) in centroids.enumerated() {
            let distance = element.squareDistance(to: centroid)
            if distance < nearestDistance {
                minIndex = index
                nearestDistance = distance
            }
        }
        return minIndex
    }
}

private extension Array {
    func randomElements(_ count: Int) -> [Element] {
        var result = Array(repeating: self[0], count: count)
        for index in 0..<count {
            let randomIndex = Int(arc4random_uniform(UInt32(self.count - 1)))
            result[index] = self[randomIndex]
        }
        return result
    }
}
