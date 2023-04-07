//
//  HsvColor.swift
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

/// A color in the HSV color space.
public struct HsvColor: AlternativeColor, Hashable {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [hue, saturation, value]
    }
    
    /// The hue component of the color.
    public var hue: Double
    
    /// The saturation component of the color.
    public var saturation: Double
    
    /// The value component of the color.
    public var value: Double
    
    public var opacity: Double
    
    public let colorSpace: HsvColorSpace
    
    // MARK: - Initialization
    
    /**
     Create a new HSV Color.
     - parameter hue: The hue component of the color.
     - parameter saturation: The saturation component of the color.
     - parameter value: The value component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(hue: Double, saturation: Double, value: Double, opacity: Double = 1, colorSpace: HsvColorSpace = HsvColorSpace()) {
        self.hue = hue
        self.saturation = saturation
        self.value = value
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    public init(_ parent: RgbColor) {
        let maxComponent = max(parent.red, parent.green, parent.blue)
        let minComponent = min(parent.red, parent.green, parent.blue)
        
        let chroma = maxComponent - minComponent
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
        
        self.value = maxComponent
        self.saturation = maxComponent == 0 ? 0 : chroma / maxComponent
        self.hue = hue * Double.pi / 180
        self.opacity = parent.opacity
        self.colorSpace = HsvColorSpace(parent: parent.colorSpace)
    }
    
    public func toParent() -> RgbColor? {
        let hue = self.hue * 180 / Double.pi
        let chroma = value * saturation
        let x = chroma * (1 - abs((hue / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = value - chroma
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
        self.init(xyzColor, colorSpace: HsvColorSpace(parent: RgbColorSpace(profile: RgbColorSpace.Profile(referenceWhite: xyzColor.colorSpace.profile.referenceWhite))))
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: HsvColorSpace) {
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
        hasher.combine(value)
        hasher.combine(saturation)
        hasher.combine(hue)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: HsvColor, rhs: HsvColor) -> Bool {
        return lhs.value == rhs.value && lhs.saturation == rhs.saturation && lhs.hue == rhs.hue && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }

}
