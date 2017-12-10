//: Playground - noun: a place where people can play

import UIKit
import KMeans

struct Vector2: KMeansElement {
    let x, y: CGFloat

    static var zeroValue: Vector2 { return .init(x: 0, y: 0) }

    func squareDistance(to vector: Vector2) -> Float {
        return Float(pow(x - vector.x, 2) + pow(y - vector.y, 2))
    }

    static func +(left: Vector2, right: Vector2) -> Vector2 {
        return .init(x: left.x + right.x,
                     y: left.y + right.y)
    }

    static func /(left: Vector2, right: Int) -> Vector2 {
        return .init(x: left.x / CGFloat(right),
                     y: left.y / CGFloat(right))
    }
}

extension Vector2: Equatable {
    static func ==(left: Vector2, right: Vector2) -> Bool {
        return left.x == right.x && left.y == right.y
    }
}

var random: CGFloat { return CGFloat(arc4random()) / CGFloat(UInt32.max) }
let vectors = (1...100).map { _ in Vector2(x: random, y: random) }
let kMeans = KMeans(elements: vectors, numberOfCentroids: 10, maxIteration: 300, convergeDistance: 0.001)

final class View: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let colors: [Int: UIColor] = kMeans
            .centroids
            .enumerated()
            .reduce(into: [Int: UIColor](), { (result, item) in
                result[item.offset] = UIColor(red: random, green: random, blue: random, alpha: 1.0)
            })

        for vector in vectors {
            let centroid = kMeans.findCentroid(of: vector)
            let index = kMeans.centroids.index(of: centroid)!
            context.setFillColor(colors[index]!.cgColor)

            let size: CGFloat = 4
            let x = vector.x * frame.width - size / 2
            let y = vector.y * frame.height - size / 2

            context.fillEllipse(in: .init(x: x, y: y, width: size, height: size))
        }

        for (index, centroid) in kMeans.centroids.enumerated() {
            let label = "Centroid[\(index)]" as NSString

            let font = UIFont.systemFont(ofSize: 16)
            let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: colors[index]!]

            let size = label.size(withAttributes: attributes)
            let x = centroid.x * frame.width - size.width / 2
            let y = centroid.y * frame.height - size.height / 2

            label.draw(at: .init(x: x, y: y), withAttributes: attributes)
        }
    }
}

let view = View(frame: .init(x: 0, y: 0, width: 600, height: 600))
