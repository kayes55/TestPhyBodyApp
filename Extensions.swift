//
//  Extensions.swift
//  TestPhyBodyApp
//
//  Created by Imrul Kayes on 1/29/18.
//  Copyright © 2018 Imrul Kayes. All rights reserved.
//

import CoreGraphics

//ADD two CGPoint values and returns a new CGPoint

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

//Increaments a CGPoint with the value of another CGPoint

public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

//Multiplies the x and y of a CGPoint and returns a new CGPoint

public func * (point: CGPoint, scaler: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scaler, y: point.y * scaler)
}

//Multiplies the x and y fields of a CGPoint

public func *= (point: inout CGPoint, scaler: CGFloat) {
    point = point * scaler
}

public extension CGFloat {
    public func degreesToRadians() -> CGFloat {
        return 3.1459 * self / 180.0
    }
    
    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / 3.1459
    }
}
