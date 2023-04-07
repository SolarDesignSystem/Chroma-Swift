//
//  XyyColor.swift
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

/**
 A color in the xyY color space.
 
 *References*
 - [Wikipedia](http://en.wikipedia.org/wiki/CIE_1931_color_space)
 */
public struct XyyColor: AlternativeColor {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [x, y, luminance]
    }
    
    /**
     The x component of the color.
     
     Expected range: [0, 1]
     */
    public var x: Double
    
    /**
     The y, component of the color.
     
     Expected range: [0, 1]
     */
    public var y: Double
    
    /**
     The  luminance component of the color.
     
     Expected range: [0, 1]
     */
    public var luminance: Double
    
    public var opacity: Double
    
    public let colorSpace: XyyColorSpace
    
    /// The chromaticity coordinate equivalent of the color.
    public var chromaticityCoordinate: XyChromaticityCoordinate {
        XyChromaticityCoordinate(x: x, y: y)
    }
    
    // MARK: - Initialization
    
    /**
     Create a new xyY color.
     - parameter x: The x component of the color.
     - parameter y: The y component of the color.
     - parameter luminance: The Y or luminance component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(x: Double, y: Double, luminance: Double, opacity: Double = 1, colorSpace: XyyColorSpace = XyyColorSpace()) {
        self.x = x
        self.y = y
        self.luminance = luminance
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: XyyColorSpace(profile: XyzColorSpace.Profile(referenceWhite: xyzColor.colorSpace.profile.referenceWhite)))
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: XyyColorSpace) {
        let convertedXyzColor: XyzColor
        if xyzColor.colorSpace.profile.referenceWhite != colorSpace.profile.referenceWhite {
            convertedXyzColor = xyzColor.adapt(to: colorSpace.profile.referenceWhite)
        } else {
            convertedXyzColor = xyzColor
        }
        
        guard convertedXyzColor.x + convertedXyzColor.y + convertedXyzColor.z > 0 else {
            return nil
        }
        
        self.x = convertedXyzColor.x / (convertedXyzColor.x + convertedXyzColor.y + convertedXyzColor.z)
        self.y = convertedXyzColor.y / (convertedXyzColor.x + convertedXyzColor.y + convertedXyzColor.z)
        self.luminance = convertedXyzColor.y
        self.opacity = convertedXyzColor.opacity
        self.colorSpace = colorSpace
    }
    
    public func toXyzColor() -> XyzColor? {
        guard y > 0 else {
            return nil
        }
        return XyzColor(x: (luminance / y) * x, y: luminance, z: (luminance / y) * (1 - x - y), colorSpace: colorSpace.parent)
    }
    
    public func toParent() -> XyzColor? {
        toXyzColor()
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(luminance)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
}
