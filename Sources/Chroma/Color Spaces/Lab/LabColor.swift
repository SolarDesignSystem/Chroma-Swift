//
//  LabColor.swift
//  Chroma
//
//  Created by Solar Design System on 6/6/20
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
 A color in the CIE 1976 L\*a\*b\* color space.
 
 *References*
 - [Bruce Lindbloom](http://www.brucelindbloom.com/index.html?Eqn_XYZ_to_Lab.html)
 - CIE 15: Technical Report: Colorimetry, 3rd edition. International Commission on Illumination. ISBN: 978-3-901906-33-6
 */
public struct LabColor: ReferenceColor, Hashable {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [luminance, a, b]
    }
    
    /**
     The luminance component of the color.
     
     Expected range: [0, ~1]
     */
    public var luminance: Double
    
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
    
    public let colorSpace: LabColorSpace
    
    // MARK: - Initialization
    
    /**
     Create a new Lab color.
     - parameter luminance: The luminance component of the color.
     - parameter a: The a component of the color.
     - parameter b: The b component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(luminance: Double, a: Double, b: Double, opacity: Double = 1, colorSpace: LabColorSpace = LabColorSpace()) {
        self.luminance = luminance
        self.a = a
        self.b = b
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    private static let ϵ: Double = 216.0 / 24389.0
    private static let κ: Double = 24389.0 / 27.0
    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: LabColorSpace(profile: LabColorSpace.Profile(referenceWhite: xyzColor.colorSpace.profile.referenceWhite)))
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: LabColorSpace) {
        let convertedXyzColor: XyzColor
        if xyzColor.colorSpace.profile.referenceWhite != colorSpace.profile.referenceWhite {
            convertedXyzColor = xyzColor.adapt(to: colorSpace.profile.referenceWhite)
        } else {
            convertedXyzColor = xyzColor
        }
        
        let whitePoint = colorSpace.profile.referenceWhite.whitePoint.xyzTristimulus(withLuminosity: 1.0)
        
        guard whitePoint.x > 0 && whitePoint.y > 0 && whitePoint.z > 0 else {
            return nil
        }
        
        let xr = convertedXyzColor.x / whitePoint.x
        let yr = convertedXyzColor.y / whitePoint.y
        let zr = convertedXyzColor.z / whitePoint.z
        
        let fx = xr > LabColor.ϵ ? Double.root(xr, 3) : ((LabColor.κ * xr) + 16) / 116
        let fy = yr > LabColor.ϵ ? Double.root(yr, 3) : ((LabColor.κ * yr) + 16) / 116
        let fz = zr > LabColor.ϵ ? Double.root(zr, 3) : ((LabColor.κ * zr) + 16) / 116
        
        self.luminance = (116 * fy - 16) / 100
        self.a = (500 * (fx - fy)) / 100
        self.b = (200 * (fy - fz)) / 100
        
        self.opacity = convertedXyzColor.opacity
        self.colorSpace = colorSpace
    }
    
    public func toXyzColor() -> XyzColor? {
        let luminance = self.luminance * 100
        let a = self.a * 100
        let b = self.b * 100
        
        let fy = (luminance + 16) / 116
        let fz = fy - (b / 200)
        let fx = (a / 500) + fy
        
        let xr: Double
        if Double.pow(fx, 3) > LabColor.ϵ {
            xr = Double.pow(fx, 3)
        } else {
            xr = ((116 * fx) - 16) / LabColor.κ
        }
        let yr: Double
        if luminance > LabColor.κ * LabColor.ϵ {
            yr = Double.pow((luminance + 16) / 116, 3)
        } else {
            yr = luminance / LabColor.κ
        }
        let zr: Double
        if Double.pow(fz, 3) <= LabColor.ϵ {
            zr = ((116 * fz) - 16) / LabColor.κ
        } else {
            zr = Double.pow(fz, 3)
        }
        
        let whitePoint = colorSpace.profile.referenceWhite.whitePoint.xyzTristimulus(withLuminosity: 1.0)
        return XyzColor(
            x: xr * whitePoint.x,
            y: yr * whitePoint.y,
            z: zr * whitePoint.z,
            opacity: opacity,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: colorSpace.profile.referenceWhite))
        )
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(luminance)
        hasher.combine(a)
        hasher.combine(b)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: LabColor, rhs: LabColor) -> Bool {
        lhs.luminance == rhs.luminance && lhs.a == rhs.a && lhs.b == rhs.b && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }
    
    
}
