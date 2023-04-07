//
//  JabColor.swift
//  Chroma
//
//  Created by Solar Design System on 12/15/21
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

import Matrix

/**
 Perceptually uniform color space for image signals including high dynamic range and wide gamut.
 
 *References*
 - Perceptually uniform color space for image signals including high dynamic range and wide gamut. Muhammad Safdar, Guihua Cui, Youn Jin Kim, Ming Ronnier Luo. doi: 10.1364/oe.25.015131
 */
public struct JabColor: ReferenceColor, Hashable {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [lightness, a, b]
    }
    
    /// The lightness component of the color.
    public var lightness: Double
    
    /// The redness-greenness of the color.
    public var a: Double
    
    /// The yellowness–blueness component of the color.
    public var b: Double
    
    public var opacity: Double
    
    public let colorSpace: JabColorSpace
    
    // MARK: - Initialization
    
    /**
     Create a new Jab color.
     - parameter lightness: The lightness component of the color.
     - parameter a: The a component of the color.
     - parameter b: The b component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(lightness: Double, a: Double, b: Double, opacity: Double = 1, colorSpace: JabColorSpace = JabColorSpace()) {
        self.lightness = lightness
        self.a = a
        self.b = b
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    private static let b = 1.15
    private static let g = 0.66
    private static let c1 = 3424 / Double.pow(2, 12)
    private static let c2 = 2413 / Double.pow(2, 7)
    private static let c3 = 2392 / Double.pow(2, 7)
    private static let n = 2610 / Double.pow(2, 14)
    private static let p = 1.7 * 2523 / Double.pow(2, 5)
    private static let d = -0.56
    private static let d0 = 1.6295499532821566e-11
    
    private static let lmsAdaptationMatrix = Matrix(
        elements: [
            0.41478972, 0.579999, 0.0146480,
            -0.2015100, 1.120649, 0.0531008,
            -0.0166008, 0.264800, 0.6684799,
        ],
        rowCount: 3,
        columnCount: 3
    )
    
    private static let iabAdaptationMatrix = Matrix(
        elements: [
            0.5, 0.5, 0,
            3.524000, -4.066708, 0.542708,
            0.199076, 1.096799, -1.295875,
        ],
        rowCount: 3,
        columnCount: 3
    )
    
    private static let quantizer: (Double) -> Double = { (a) in
        let part1 = Double.pow(a / 10000, n)
        return Double.pow((c1 + c2 * part1) / (1 + c3 * part1), p)
    }
    
    private static let inverseQuantizer: (Double) -> Double = { (a) in
        let part1 = Double.pow(a, 1 / JabColor.p)
        return 10000 * Double.pow((c1 - part1) / ((c3 * part1) - c2), 1 / n)
    }
    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: JabColorSpace())
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: JabColorSpace) {
        let convertedXyzColor: XyzColor
        if xyzColor.colorSpace.profile.referenceWhite != colorSpace.profile.referenceWhite {
            convertedXyzColor = xyzColor.adapt(to: colorSpace.profile.referenceWhite)
        } else {
            convertedXyzColor = xyzColor
        }
        
        let xPrime = (JabColor.b * convertedXyzColor.x) - ((JabColor.b - 1) * convertedXyzColor.z)
        let yPrime = (JabColor.g * convertedXyzColor.y) - ((JabColor.g - 1) * convertedXyzColor.x)
        
        let lms = JabColor.lmsAdaptationMatrix * Matrix(elements: [xPrime, yPrime, xyzColor.z], rowCount: 3, columnCount: 1)
        let lmsPrime = Matrix(
            elements: [
                JabColor.quantizer(lms[0, 0]),
                JabColor.quantizer(lms[1, 0]),
                JabColor.quantizer(lms[2, 0])
            ],
            rowCount: 3,
            columnCount: 1
        )
        
        let iab = JabColor.iabAdaptationMatrix * lmsPrime
        
        let j = (((1 + JabColor.d) * iab[0, 0]) / (1 + (JabColor.d * iab[0, 0]))) - JabColor.d0
        
        self.lightness = j
        self.a = iab[1, 0]
        self.b = iab[2, 0]
        self.opacity = convertedXyzColor.opacity
        self.colorSpace = colorSpace
    }
    
    public func toXyzColor() -> XyzColor? {
        let i = (lightness + JabColor.d0) / (1 + JabColor.d - (JabColor.d * (lightness + JabColor.d0)))
        
        let lmsPrime: Matrix<Double> = JabColor.iabAdaptationMatrix.inverse * Matrix(elements: [i, a, b], rowCount: 3, columnCount: 1)
        let lms = Matrix(
            elements: [
                JabColor.inverseQuantizer(lmsPrime[0, 0]),
                JabColor.inverseQuantizer(lmsPrime[1, 0]),
                JabColor.inverseQuantizer(lmsPrime[2, 0])
            ],
            rowCount: 3,
            columnCount: 1
        )
        
        let xpYpZ = JabColor.lmsAdaptationMatrix.inverse * lms
        let x = (xpYpZ[0, 0] + ((JabColor.b - 1) * xpYpZ[2, 0])) / JabColor.b
        let y = (xpYpZ[1, 0] + ((JabColor.g - 1) * x)) / JabColor.g
        
        return XyzColor(x: x, y: y, z: xpYpZ[2, 0], opacity: opacity, colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: colorSpace.profile.referenceWhite)))
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lightness)
        hasher.combine(a)
        hasher.combine(b)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: JabColor, rhs: JabColor) -> Bool {
        lhs.lightness == rhs.lightness && lhs.a == rhs.a && lhs.b == rhs.b && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }
    
}
