//
//  XyzColor.swift
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

/// A color in the XYZ color space.
public struct XyzColor: ReferenceColor {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [x, y, z]
    }
    
    
    /// The X component of the color.
    /// Expected range: [0, ~1]
    public var x: Double
    
    
    /// The Y, or luminance component of the color.
    /// Expected range: [0, ~1]
    public var y: Double
    
    /// The Z component of the color.
    /// Expected range: [0, ~1]
    public var z: Double
    
    public var opacity: Double
    
    public let colorSpace: XyzColorSpace
    
    // MARK: - Initialization
    
    /// Create a new XYZ color.
    /// - Parameters:
    ///   - x: The X component of the color.
    ///   - y: The Y, or luminance component of the color.
    ///   - z: The Z component of the color.
    ///   - opacity: The opacity of the color.
    ///   - colorSpace: The color space associated with this color.
    public init(x: Double, y: Double, z: Double, opacity: Double = 1, colorSpace: XyzColorSpace = XyzColorSpace()) {
        self.x = x
        self.y = y
        self.z = z
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: xyzColor.colorSpace)
    }
    
    /// Creates a new color from a color in the XYZ color space using the default color space for the chosen type of color. The initializer will return nil if the XYZ color is unable to be converted.
    /// - Parameters:
    ///   - xyzColor: The equivalent XYZ color to convert to this color type.
    ///   - colorSpace: The color space to use for the new color.
    public init?(_ xyzColor: XyzColor, colorSpace: XyzColorSpace) {
        let convertedXyzColor: XyzColor
        if xyzColor.colorSpace.profile.referenceWhite != colorSpace.profile.referenceWhite {
            convertedXyzColor = xyzColor.adapt(to: colorSpace.profile.referenceWhite)
        } else {
            convertedXyzColor = xyzColor
        }
        
        self.x = convertedXyzColor.x
        self.y = convertedXyzColor.y
        self.z = convertedXyzColor.z
        self.opacity = convertedXyzColor.opacity
        self.colorSpace = colorSpace
    }
    
    public func toXyzColor() -> XyzColor? {
        XyzColor(x: x, y: y, z: z, opacity: opacity, colorSpace: colorSpace)
    }
    
    /// Adapts this color to the given standard illuminant.
    /// - Parameter referenceWhite: The reference illuminant to adapt this color to.
    /// - Returns: The equivalent of this XYZ color adapted to the specified reference illuminant.
    /// - Note: Currently this uses a linear adaptation method with the Bradford transformation matrix.
    public func adapt(to referenceWhite: StandardIlluminant) -> XyzColor {
        adapt(usingMethod: ChromaticAdaptationMethodLinear(adaptationTransform: .bradford, referenceIlluminant: referenceWhite))
    }
    
    /// Adapts this color using the given chromatic adaptation method.
    /// - Parameter method: The chromatic adaptation method to use.
    /// - Returns: The equivalent of this XYZ color adapted to the specified reference illuminant.
    public func adapt(usingMethod method: ChromaticAdaptationMethod) -> XyzColor {
        method(self)
    }

    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: XyzColor, rhs: XyzColor) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }
    
}
