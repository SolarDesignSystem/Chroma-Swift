//
//  JchColor.swift
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

import RealModule

/**
 A color in the Jch color space.
 
 *References*
 - Perceptually uniform color space for image signals including high dynamic range and wide gamut. Muhammad Safdar, Guihua Cui, Youn Jin Kim, Ming Ronnier Luo. doi: 10.1364/oe.25.015131
 */
public struct JchColor: AlternativeColor {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [lightness, chroma, hue]
    }
    
    /// The lightness component of the color.
    public var lightness: Double
    
    /// The chroma component of the color.
    public var chroma: Double
    
    /// The hue component of the color.
    public var hue: Double
    
    public var opacity: Double
    
    public let colorSpace: JchColorSpace
    
    // MARK: - Initialization
    
    /**
     Create a new Jch Color.
     - parameter lightness: The lightness component of the color.
     - parameter chroma: The chroma component of the color.
     - parameter hue: The hue component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(lightness: Double, chroma: Double, hue: Double, opacity: Double = 1, colorSpace: JchColorSpace = JchColorSpace()) {
        self.lightness = lightness
        self.chroma = chroma
        self.hue = hue
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    public init(_ parent: JabColor) {
        self.lightness = parent.lightness
        self.chroma = Double.sqrt(Double.pow(parent.a, 2) + Double.pow(parent.b, 2))
        let possibleHue = Double.atan2(y: parent.b, x: parent.a)
        self.hue = possibleHue >= 0 ? possibleHue : possibleHue + (2 * Double.pi)
        self.opacity = parent.opacity
        self.colorSpace = JchColorSpace(parent: parent.colorSpace)
    }
    
    public func toParent() -> JabColor? {
        JabColor(
            lightness: lightness,
            a: chroma * Double.cos(hue),
            b: chroma * Double.sin(hue),
            opacity: opacity,
            colorSpace: colorSpace.parent)
    }
    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: JchColorSpace(profile: JabColorSpace.Profile()))
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: JchColorSpace) {
        guard let jabColor = JabColor(xyzColor, colorSpace: colorSpace.parent) else {
            return nil
        }
        self.init(jabColor)
    }
    
    public func toXyzColor() -> XyzColor? {
        return toParent()?.toXyzColor()
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lightness)
        hasher.combine(chroma)
        hasher.combine(hue)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: JchColor, rhs: JchColor) -> Bool {
        return lhs.lightness == rhs.lightness && lhs.chroma == rhs.chroma && lhs.hue == rhs.hue && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }

}
