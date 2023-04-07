//
//  RgbColor.swift
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

import Matrix

/// A color in the Rgb color space.
public struct RgbColor: ReferenceColor, Hashable {
    
    // MARK: - Properties
    
    public var components: [Double] {
        return [red, green, blue]
    }
    
    /// The red component of the color.
    public var red: Double
    
    /// The green of the color.
    public var green: Double
    
    /// The blue component of the color.
    public var blue: Double
    
    public var opacity: Double
    
    public let colorSpace: RgbColorSpace
    
    // MARK: - Initialization
    
    /**
     Create a new RGB color.
     - parameter red: The red component of the color.
     - parameter green: The green component of the color.
     - parameter blue: The blue component of the color.
     - parameter opacity: The opacity of the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(red: Double, green: Double, blue: Double, opacity: Double = 1, colorSpace: RgbColorSpace = RgbColorSpace()) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
        self.colorSpace = colorSpace
    }
    
    // MARK: - Color Conversion
    
    private static let ϵ: Double = 216.0 / 24389.0
    private static let κ: Double = 24389.0 / 27.0
    
    public init?(_ xyzColor: XyzColor) {
        self.init(xyzColor, colorSpace: RgbColorSpace(profile: RgbColorSpace.Profile(referenceWhite: xyzColor.colorSpace.profile.referenceWhite)))
    }
    
    public init?(_ xyzColor: XyzColor, colorSpace: RgbColorSpace) {
        let convertedXyzColor: XyzColor
        if xyzColor.colorSpace.profile.referenceWhite != colorSpace.profile.referenceWhite {
            convertedXyzColor = xyzColor.adapt(to: colorSpace.profile.referenceWhite)
        } else {
            convertedXyzColor = xyzColor
        }
        
        let linearRgb = colorSpace.profile.toRgbConversionMatrix * xyzColor.matrixForm
        
        let transformedRgb: Matrix<Double>
        switch colorSpace.profile.compandingFunction {
        case .linear:
            transformedRgb = linearRgb
        case let .gamma(γ):
            transformedRgb = linearRgb.map({ Double.pow($0, 1.0 / γ) })
        case .sRgb:
            transformedRgb = linearRgb.map({ $0 <= 0.0031308 ? 12.92 * $0 : (1.055 * Double.pow($0, 1.0 / 2.4)) - 0.055 })
        case .luminance:
            transformedRgb = linearRgb.map({ $0 <= RgbColor.ϵ ? ($0 * RgbColor.κ) / 100.0 : (1.16 * Double.root($0, 3)) - 0.16 })
        case let .parametricType3(γ, a, b, c, d):
            transformedRgb = linearRgb.map({ $0 >= d ? Double.pow(a * $0 + b, γ) : c * $0 })
        }
        
        self.red = transformedRgb[0, 0]
        self.green = transformedRgb[1, 0]
        self.blue = transformedRgb[2, 0]
        self.opacity = convertedXyzColor.opacity
        self.colorSpace = colorSpace
    }
    
    public func toXyzColor() -> XyzColor? {
        let rgb = matrixForm
        let linearRgb: Matrix<Double>
        switch colorSpace.profile.compandingFunction {
        case .linear:
            linearRgb = rgb
        case let .gamma(γ):
            linearRgb = rgb.map({ Double.pow($0, γ) })
        case .sRgb:
            linearRgb = rgb.map({ $0 <= 0.04045 ? $0 / 12.92 : Double.pow(($0 + 0.055) / 1.055, 2.4) })
        case .luminance:
            linearRgb = rgb.map({ $0 <= 0.08 ? (100 * $0) / RgbColor.κ : Double.pow(($0 + 0.16) / 1.16, 3) })
        case let .parametricType3(γ, a, b, c, d):
            let limit = Double.pow(a * d + b, γ)
            linearRgb = rgb.map({ $0 >= limit ? (Double.pow($0, 1 / γ) - b) / a : $0 / c })
        }
        
        let xyz = colorSpace.profile.toXyzConversionMatrix * linearRgb
        
        return XyzColor(x: xyz[0, 0], y: xyz[1, 0], z: xyz[2, 0], opacity: opacity, colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: colorSpace.profile.referenceWhite)))
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(red)
        hasher.combine(green)
        hasher.combine(blue)
        hasher.combine(opacity)
        hasher.combine(colorSpace)
    }
    
    public static func ==(lhs: RgbColor, rhs: RgbColor) -> Bool {
        lhs.red == rhs.red && lhs.green == rhs.green && lhs.blue == rhs.blue && lhs.opacity == rhs.opacity && lhs.colorSpace == rhs.colorSpace
    }
    
}

#if canImport(Foundation)

import Foundation

extension RgbColor {
    
    /**
     Create a new RGB color.
     - parameter hex: The hex string representing the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init?(hex: String, colorSpace: RgbColorSpace = RgbColorSpace()) {
        let trimmedHex = hex.replacingOccurrences(of: "#", with: "")
        guard let integerValue = Int64(trimmedHex, radix: 16) else {
            return nil
        }
        self.init(hex: integerValue, colorSpace: colorSpace)
    }
    
    /**
     Create a new RGB color.
     - parameter hex: The hex integer representing the color.
     - parameter colorSpace: The color space associated with this color.
    */
    public init(hex: Int64, colorSpace: RgbColorSpace = RgbColorSpace()) {
        self.red = Double((hex >> 16) & 0xFF) / 255.0
        self.green = Double((hex >> 8) & 0xFF) / 255.0
        self.blue = Double(hex & 0xFF) / 255.0
        self.opacity = 1
        self.colorSpace = colorSpace
    }
}

#endif
