//
//  LchAbColor.swift
//  Chroma
//
//  Created by Solar Design System on 6/10/20
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
 A color in the CIE 1976 L\*c\*h\*(ab) color space.
 
 *References*
 - CIE 15: Technical Report: Colorimetry, 3rd edition. International Commission on Illumination. ISBN: 978-3-901906-33-6
 */
public struct LchAbColor: AlternativeColor {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [luminance, chroma, hue]
    }
    
    /**
     The luminance component of the color.
     
     Expected range: [0, ~1]
     */
    public var luminance: Double
    
    /**
     The chroma component of the color.
     
     Expected range: [0, 1]
     */
    public var chroma: Double
    
    /**
     The hue component of the color.
     
     Expected range: [0, 2π]
     */
    public var hue: Double
    
    public var opacity: Double
    
    public let colorSpace: LchAbColorSpace
    
    // MARK: - Initialization
    
    /**
     Create a new Lch Color.
     - parameter luminance: The luminance component of the color.
     - parameter chroma: The chroma component of the color.
     - parameter hue: The hue component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(luminance: Double, chroma: Double, hue: Double, opacity: Double = 1, colorSpace: LchAbColorSpace = LchAbColorSpace()) {
        self.luminance = luminance
        self.chroma = chroma
        self.hue = hue
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    public init(_ parent: LabColor) {
        self.luminance = parent.luminance
        self.chroma = Double.sqrt(Double.pow(parent.a, 2) + Double.pow(parent.b, 2))
        let possibleHue = Double.atan2(y: parent.b, x: parent.a)
        self.hue = possibleHue >= 0 ? possibleHue : possibleHue + (2 * Double.pi)
        self.opacity = parent.opacity
        self.colorSpace = LchAbColorSpace(parent: parent.colorSpace)
    }
    
    public func toParent() -> LabColor? {
        LabColor(
            luminance: luminance,
            a: chroma * Double.cos(hue),
            b: chroma * Double.sin(hue),
            opacity: opacity,
            colorSpace: colorSpace.parent)
    }
    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: LchAbColorSpace(profile: LabColorSpace.Profile(referenceWhite: xyzColor.colorSpace.profile.referenceWhite)))
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: LchAbColorSpace) {
        guard let labColor = LabColor(xyzColor, colorSpace: colorSpace.parent) else {
            return nil
        }
        self.init(labColor)
    }
    
    public func toXyzColor() -> XyzColor? {
        return toParent()?.toXyzColor()
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(luminance)
        hasher.combine(chroma)
        hasher.combine(hue)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: LchAbColor, rhs: LchAbColor) -> Bool {
        return lhs.luminance == rhs.luminance && lhs.chroma == rhs.chroma && lhs.hue == rhs.hue && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }

}
