//
//  HslColor.swift
//  Chroma
//
//  Created by Solar Design System on 6/19/20
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

/// A color in the HSL color space.
public struct HslColor: AlternativeColor, Hashable {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [hue, saturation, lightness]
    }
    
    /// The hue component of the color.
    public var hue: Double
    
    /// The saturation component of the color.
    public var saturation: Double
    
    /// The lightness component of the color.
    public var lightness: Double
    
    public var opacity: Double
    
    public let colorSpace: HslColorSpace
    
    // MARK: - Initialization
    
    /**
     Create a new HSL Color.
     - parameter hue: The hue component of the color.
     - parameter saturation: The saturation component of the color.
     - parameter lightness: The lightness component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(hue: Double, saturation: Double, lightness: Double, opacity: Double = 1, colorSpace: HslColorSpace = HslColorSpace()) {
        self.hue = hue
        self.saturation = saturation
        self.lightness = lightness
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    public init(_ parent: RgbColor) {
        let maxComponent = max(parent.red, parent.green, parent.blue)
        let minComponent = min(parent.red, parent.green, parent.blue)
        
        let chroma = maxComponent - minComponent
        let lightness = (maxComponent + minComponent) / 2
        let hue: Double
        if chroma == 0 {
            hue = 0
        } else if maxComponent == parent.red {
            hue = 60 * (parent.green - parent.blue) / chroma
        } else if maxComponent == parent.green {
            hue = 60 * (2 + (parent.blue - parent.red) / chroma)
        } else if maxComponent == parent.blue {
            hue = 60 * (4 + (parent.red - parent.green) / chroma)
        } else {
            hue = 0
        }
        
        self.lightness = lightness
        self.saturation = lightness == 0 || lightness == 1 ? 0 : chroma / (1 - abs(2.0 * maxComponent - chroma - 1))
        self.hue = hue * Double.pi / 180
        self.opacity = parent.opacity
        self.colorSpace = HslColorSpace(parent: parent.colorSpace)
    }
    
    public func toParent() -> RgbColor? {
        let hue = self.hue * 180 / Double.pi
        let chroma = (1 - abs(2 * lightness - 1)) * saturation
        let x = chroma * (1 - abs((hue / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = lightness - chroma / 2
        let r: Double
        let g: Double
        let b: Double
        
        if 0 <= hue && hue < 60 {
            r = chroma
            g = x
            b = 0
        } else if 60 <= hue && hue < 120 {
            r = x
            g = chroma
            b = 0
        } else if 120 <= hue && hue < 180 {
            r = 0
            g = chroma
            b = x
        } else if 180 <= hue && hue < 240 {
            r = 0
            g = x
            b = chroma
        } else if 240 <= hue && hue < 300 {
            r = x
            g = 0
            b = chroma
        } else if 300 <= hue && hue < 360 {
            r = chroma
            g = 0
            b = x
        } else {
            r = 0
            g = 0
            b = 0
        }
        
        return RgbColor(red: r + m, green: g + m, blue: b + m, opacity: opacity, colorSpace: colorSpace.parent)
    }
    

    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: HslColorSpace(parent: RgbColorSpace(profile: RgbColorSpace.Profile(referenceWhite: xyzColor.colorSpace.profile.referenceWhite))))
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: HslColorSpace) {
        guard let rgbColor = RgbColor(xyzColor, colorSpace: colorSpace.parent) else {
            return nil
        }
        self.init(rgbColor)
    }
    
    public func toXyzColor() -> XyzColor? {
        return toParent()?.toXyzColor()
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lightness)
        hasher.combine(saturation)
        hasher.combine(hue)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: HslColor, rhs: HslColor) -> Bool {
        return lhs.lightness == rhs.lightness && lhs.saturation == rhs.saturation && lhs.hue == rhs.hue && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }

}
