//
//  RgbColorSpace.swift
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

/// A three component, device dependant color model that defines colors using the primitives: red, green, and blue.
public final class RgbColorSpace: ReferenceColorSpace, Hashable {
    
    // MARK: - Profile
    
    /// The function to use when transforming RGB values.
    public enum CompandingFunction: Hashable {
        
        // MARK: - Cases
        
        /// A linear transformation between the unscaled and scaled RGB vales.
        case linear
        
        /// Transforms the RGB values using the Ɣ function.
        case gamma(Double)
        
        /// Transforms the RGB values using the sRGB standard function.
        case sRgb
        
        /// Transforms the RGB values based on luminance.
        case luminance
        
        /// Transforms the RGB values based on a type 3 parametric curve.
        case parametricType3(γ: Double, a: Double, b: Double, c: Double, d: Double)
    }
    
    /// Defines the necessary constants to define the color space mathematically.
    public struct Profile: ReferenceColorSpaceProfile, Hashable {
        
        // MARK: - Properties
        
        public var referenceWhite: StandardIlluminant
        
        public var compandingFunction: CompandingFunction
        
        public var redCoordinate: XyChromaticityCoordinate
        
        public var greenCoordinate: XyChromaticityCoordinate
        
        public var blueCoordinate: XyChromaticityCoordinate
        
        public var toRgbConversionMatrix: Matrix<Double>
        
        public var toXyzConversionMatrix: Matrix<Double>
        
        // MARK: - Initialization
        
        public init() {
            self.init(
                referenceWhite: StandardIlluminant.TwoDegree.d65,
                compandingFunction: .sRgb,
                redCoordinate: XyChromaticityCoordinate(x: 0.64, y: 0.33),
                greenCoordinate: XyChromaticityCoordinate(x: 0.30, y: 0.60),
                blueCoordinate: XyChromaticityCoordinate(x: 0.15, y: 0.06)
            )
        }
        
        public init(referenceWhite: StandardIlluminant) {
            self.init(
                referenceWhite: referenceWhite,
                compandingFunction: .sRgb,
                redCoordinate: XyChromaticityCoordinate(x: 0.64, y: 0.33),
                greenCoordinate: XyChromaticityCoordinate(x: 0.30, y: 0.60),
                blueCoordinate: XyChromaticityCoordinate(x: 0.15, y: 0.06)
            )
        }
        
        public init(referenceWhite: StandardIlluminant, compandingFunction: CompandingFunction, redCoordinate: XyChromaticityCoordinate, greenCoordinate: XyChromaticityCoordinate, blueCoordinate: XyChromaticityCoordinate, toRgbConversionMatrix: Matrix<Double>? = nil, toXyzConversionMatrix: Matrix<Double>? = nil) {
            self.referenceWhite = referenceWhite
            self.compandingFunction = compandingFunction
            self.redCoordinate = redCoordinate
            self.greenCoordinate = greenCoordinate
            self.blueCoordinate = blueCoordinate
            
            let tempToXyzConversionMatrix: Matrix<Double>
            if let toXyzConversionMatrix = toXyzConversionMatrix {
                self.toXyzConversionMatrix = toXyzConversionMatrix
                tempToXyzConversionMatrix = toXyzConversionMatrix
            } else {
                let xyzR = redCoordinate.xyzTristimulus().matrixForm
                let xyzG = greenCoordinate.xyzTristimulus().matrixForm
                let xyzB = blueCoordinate.xyzTristimulus().matrixForm
                
                let xyzRgb = Matrix(
                    elements: [
                        xyzR[0, 0], xyzG[0, 0], xyzB[0, 0],
                        xyzR[1, 0], xyzG[1, 0], xyzB[1, 0],
                        xyzR[2, 0], xyzG[2, 0], xyzB[2, 0]
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
                
                let Srgb = xyzRgb.inverse * referenceWhite.whitePoint.xyzTristimulus().matrixForm
                
                tempToXyzConversionMatrix = Matrix(
                    elements: [
                        Srgb[0, 0] * xyzR[0, 0], Srgb[1, 0] * xyzG[0, 0], Srgb[2, 0] * xyzB[0, 0],
                        Srgb[0, 0] * xyzR[1, 0], Srgb[1, 0] * xyzG[1, 0], Srgb[2, 0] * xyzB[1, 0],
                        Srgb[0, 0] * xyzR[2, 0], Srgb[1, 0] * xyzG[2, 0], Srgb[2, 0] * xyzB[2, 0]
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
                self.toXyzConversionMatrix = tempToXyzConversionMatrix
            }
            
            if let toRgbConversionMatrix = toRgbConversionMatrix {
                self.toRgbConversionMatrix = toRgbConversionMatrix
            } else {
                self.toRgbConversionMatrix = tempToXyzConversionMatrix.inverse
            }
        }
        
    }
    
    // MARK: - Properties
    
    public let model: ColorModel = ColorModel(name: "RGB", components: [
        ColorModel.Component(name: "red", abbreviation: "R", description: ""),
        ColorModel.Component(name: "green", abbreviation: "G", description: ""),
        ColorModel.Component(name: "blue", abbreviation: "B", description: ""),
    ])
    
    /// The numerical model of the color space.
    public let profile: Profile
    
    // MARK: - Initialization
    
    /// Creates a new OkLab color space using the D65 illuminant with a 2° observer.
    public convenience init() {
        self.init(profile: Profile())
    }
    
    /**
     Creates a new OkLab color space.
     - parameter profile: The profile used to mathematically define the color space.
     */
    public init(profile: Profile) {
        self.profile = profile
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
        hasher.combine(profile)
    }
    
    public static func ==(lhs: RgbColorSpace, rhs: RgbColorSpace) -> Bool {
        lhs.profile == rhs.profile
    }
    
}

extension RgbColorSpace {
    
    /**
     The Display P3 color space for displays. This is the color space Apple uses for its devices.
     
     *References*
     - [Wikipedia](https://en.wikipedia.org/wiki/DCI-P3)
     */
    public static let p3Display = RgbColorSpace(profile:
            Profile(
                referenceWhite: StandardIlluminant.TwoDegree.d65,
                compandingFunction: .parametricType3(γ: 2.4, a: 0.948, b: 0.052, c: 0.077, d: 0.04),
                redCoordinate: XyChromaticityCoordinate(x: 0.680, y: 0.320),
                greenCoordinate: XyChromaticityCoordinate(x: 0.265, y: 0.690),
                blueCoordinate: XyChromaticityCoordinate(x: 0.150, y: 0.060)
            )
        )
    
    /**
     The standard sRGB color space.
     
     *References*
     - [Multimedia systems and equipment - Colour measurement and management - Part 2-1: Colour management - Default RGB colour space - sRGB.  International Electrotechnical Commission.](https://webstore.iec.ch/publication/6169)
     - [Parameter values for the HDTV standards for production and international programme exchange. International Telecommunication Union](https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.709-6-201506-I!!PDF-E.pdf)
     */
    public static let sRgb = RgbColorSpace(profile:
            Profile(
                referenceWhite: StandardIlluminant.TwoDegree.d65,
                compandingFunction: .sRgb,
                redCoordinate: XyChromaticityCoordinate(x: 0.64, y: 0.33),
                greenCoordinate: XyChromaticityCoordinate(x: 0.30, y: 0.60),
                blueCoordinate: XyChromaticityCoordinate(x: 0.15, y: 0.06),
                toRgbConversionMatrix: Matrix(
                    elements: [
                        3.2406, -1.5372, -0.4986,
                        -0.9689, 1.8758, 0.0415,
                        0.0557, -0.2040, 1.0570
                    ],
                    rowCount: 3,
                    columnCount: 3
                ),
                toXyzConversionMatrix: Matrix(
                    elements: [
                        0.4124, 0.3576, 0.1805,
                        0.2126, 0.7152, 0.0722,
                        0.0193, 0.1192, 0.9505
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            )
        )
    
   
    
    
    
    
}
