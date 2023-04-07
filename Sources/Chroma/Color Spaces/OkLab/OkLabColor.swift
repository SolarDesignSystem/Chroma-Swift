//
//  OkLabColor.swift
//  Chroma
//
//  Created by Solar Design System on 12/31/21
//  Copyright (c) 2021 Solar Design System
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
 A color in the OkLab color space.
 
 *References*
 - [A perceptual color space for image processing. Björn Ottosson.](https://bottosson.github.io/posts/oklab/)
 */
public struct OkLabColor: ReferenceColor, Hashable {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [lightness, a, b]
    }
    
    /**
     The lightness component of the color.
     
     Expected range: [0, ~1]
     */
    public var lightness: Double
    
    /**
     The a component of the color.
     
     Expected range: [-1, 1]
     */
    public var a: Double
    
    /**
     The b component of the color.
     
     Expected range: [-1, 1]
     */
    public var b: Double
    
    public var opacity: Double
    
    public let colorSpace: OkLabColorSpace
    
    // MARK: - Initialization
    
    /**
     Create a new OkLab color.
     - parameter lightness: The lightness component of the color.
     - parameter a: The a component of the color.
     - parameter b: The b component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(lightness: Double, a: Double, b: Double, opacity: Double = 1, colorSpace: OkLabColorSpace = OkLabColorSpace()) {
        self.lightness = lightness
        self.a = a
        self.b = b
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    private static let m1 = Matrix(
        elements: [
            0.8189330101, 0.3618667424, -0.1288597137,
            0.0329845436, 0.9293118715, 0.0361456387,
            0.0482003018, 0.2643662691, 0.6338517070
        ],
        rowCount: 3,
        columnCount: 3
    )
    
    private static let m2 = Matrix(
        elements: [
            0.2104542553, 0.7936177850, -0.0040720468,
            1.9779984951, -2.4285922050, 0.4505937099,
            0.0259040371, 0.7827717662, -0.8086757660
        ],
        rowCount: 3,
        columnCount: 3
    )
    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: OkLabColorSpace())
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: OkLabColorSpace) {
        let convertedXyzColor: XyzColor
        if xyzColor.colorSpace.profile.referenceWhite != colorSpace.profile.referenceWhite {
            convertedXyzColor = xyzColor.adapt(to: colorSpace.profile.referenceWhite)
        } else {
            convertedXyzColor = xyzColor
        }
        
        let lms = OkLabColor.m1 * convertedXyzColor.matrixForm
        let lmsPrime = lms.map({ Double.pow($0, 1.0 / 3.0) })
        let lab = OkLabColor.m2 * lmsPrime
        
        self.lightness = lab[0, 0]
        self.a = lab[1, 0]
        self.b = lab[2, 0]
        self.opacity = convertedXyzColor.opacity
        self.colorSpace = colorSpace
    }
    
    public func toXyzColor() -> XyzColor? {
        
        let lmsPrime = OkLabColor.m2.inverse * matrixForm
        let lms = lmsPrime.map({ Double.pow($0, 3) })
        let xyz = OkLabColor.m1.inverse * lms
        
        return XyzColor(
            x: xyz[0, 0],
            y: xyz[1, 0],
            z: xyz[2, 0],
            opacity: opacity,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: colorSpace.profile.referenceWhite))
        )
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lightness)
        hasher.combine(a)
        hasher.combine(b)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: OkLabColor, rhs: OkLabColor) -> Bool {
        lhs.lightness == rhs.lightness && lhs.a == rhs.a && lhs.b == rhs.b && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }
    
    
}
