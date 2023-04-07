//
//  ChromaticityCoordinate.swift
//  Chroma
//
//  Created by Solar Design System on 12/19/21
//  Copyright (c) 2020 Solar Design System
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// A location in the CIE xy chromaticity diagram.
public struct XyChromaticityCoordinate: Hashable {
    
    // MARK: - Properties
    
    /// The x value of the coordinate.
    public var x: Double
    
    /// The y value of the coordinate.
    public var y: Double
    
    /// The z value of the coordinate.
    public var z: Double {
        return 1 - x - y
    }
    
    // MARK: - Initialization
    
    
    /// Creates a new chromaticity coordinate.
    /// - Parameters:
    ///   - x: The x value of the coordinate.
    ///   - y: The y value of the coordinate.
    public init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }
    
}

extension XyChromaticityCoordinate {
    
    // MARK: - XYZ Tristimulus Conversions.
    
    
    /// Calculates the equivalent value in the XYZ color space.
    /// - Parameter yTristimulus: The luminosity of the resulting color.
    /// - Returns: An `XYZColor` with the given chromacity and luminosity.
    public func xyzTristimulus(withLuminosity yTristimulus: Double = 1) -> XyzColor {
        let xTristimulus = (yTristimulus / y) * x
        let zTristimulus = (yTristimulus / y) * (1.0 - x - y)
        return XyzColor(x: xTristimulus, y: yTristimulus, z: zTristimulus)
    }
    
    
    /// Creates a new chromaticity coordinate using the given value in the XYZ color space.
    /// - Parameters:
    ///   - x: The X value of the XYZ color.
    ///   - y: The Y value of the XYZ color.
    ///   - z: The Z value of the XYZ color.
    public init(tristimulusX x: Double, y: Double, z: Double) {
        self.x = x / (x + y + z)
        self.y = y / (x + y + z)
    }
    
    /**
     Converts the coordinate to an UV chromaticity coordinate.
     */
//    public func toUvChromaticityCoordinate() -> UvChromaticityCoordinate {
//        return UvChromaticityCoordinate(
//            u: (4 * x) / (12 * y - 2 * x + 3),
//            v: (6 * y) / (12 * y - 2 * x + 3)
//        )
//    }
    
}
