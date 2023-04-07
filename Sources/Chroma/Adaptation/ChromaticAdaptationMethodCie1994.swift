//
//  ChromaticAdaptationMethodCie1994.swift
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

import RealModule


///  Adapts colors from one environment to another using the CIE 1994 chromatic adaptation method.
/// *References*
/// - A Method of Predicting Corresponding Colours under Different Chromatic and Illuminance Adaptations. CIE INTERNATIONAL COMMISSION ON ILLUMINATION. ISBN: 978-3-900734-51-0
public struct ChromaticAdaptationMethodCie1994: ChromaticAdaptationMethod {
    
    // MARK: - Properties
    
    /// The chromaticity coordinates of reference illuminant and background.
    var referenceIlluminant: StandardIlluminant
    
    /// The test illuminance. (lux)
    var testIlluminance: Double
    
    /// The reference illuminance. (lux)
    var referenceIlluminance: Double
    
    /// The Y tristimulus value given as a percentage of the test and reference backgrounds.
    ///
    /// Set to 1 for the perfect reflecting diffuser.
    var yTristimulusPercentage: Double
    
    // MARK: - Initialization
    
    /// Create a new adaptation.
    /// - Parameters:
    ///   - testIlluminance: The test illuminance. (lux)
    ///   - referenceIlluminant: The chromaticity coordinates of reference illuminant and background.
    ///   - referenceIlluminance: The reference illuminance. (lux)
    ///   - yTristimulusPercentage: The Y tristimulus value given as a percentage of the test and reference backgrounds.
    public init(testIlluminance: Double, referenceIlluminant: StandardIlluminant, referenceIlluminance: Double, yTristimulusPercentage: Double) {
        self.testIlluminance = testIlluminance
        self.referenceIlluminant = referenceIlluminant
        self.referenceIlluminance = referenceIlluminance
        self.yTristimulusPercentage = yTristimulusPercentage
    }
    
    // MARK: - Adaptation

    public func callAsFunction(_ xyzColor: XyzColor) -> XyzColor {
        
        // Symbol key:
        // (X1, Y1, Z1)     = xyzColor
        // (X2, Y2, Z2)     = return value
        // (x01, y01)       = testIlluminant
        // (x02, y02)       = referenceIlluminant
        // E01              = testIlluminance
        // E02              = referenceIlluminance
        // Y0               = yTristimulusPercentage
        
        let testIlluminant = xyzColor.colorSpace.profile.referenceWhite.whitePoint
        let referenceIlluminant = self.referenceIlluminant.whitePoint
        
        // Step 1: Transform the input value to the fundamental primary system.
        let R1: Double = 0.40024 * xyzColor.x * 100 + 0.70760 * xyzColor.y * 100 - 0.08081 * xyzColor.z * 100
        let G1: Double = -0.22630 * xyzColor.x * 100 + 1.16532 * xyzColor.y * 100 + 0.04570 * xyzColor.z * 100
        let B1: Double = 0.91822 * xyzColor.z * 100
        
        // Step 2: Transform the fundamental values from the previous step to the tristimulus values of the corresponding colour in the reference field.
        
        // Step 2 - Note 1: Calculate the transformed relative chromaticity coordinate.
        let (ξ1, η1, ζ1) = transformedRelativeChromacityCoordinates(from: testIlluminant)
        let (ξ2, η2, ζ2) = transformedRelativeChromacityCoordinates(from: referenceIlluminant)
        
        // Step 2 - Note 2: Calculate the effective adapting responses in the fundamental primary system of the test field.
        let r01: Double = ξ1 * (yTristimulusPercentage * testIlluminance) / Double.pi
        let g01: Double = η1 * (yTristimulusPercentage * testIlluminance) / Double.pi
        let b01: Double = ζ1 * (yTristimulusPercentage * testIlluminance) / Double.pi
        let r02: Double = ξ2 * (yTristimulusPercentage * referenceIlluminance) / Double.pi
        let g02: Double = η2 * (yTristimulusPercentage * referenceIlluminance) / Double.pi
        let b02: Double = ζ2 * (yTristimulusPercentage * referenceIlluminance) / Double.pi
        
        // Step 2 - Note 3: Calculate the exponents of red, green and blue transformations.
        let β1r01: Double = (6.469 + 6.362 * Double.pow(r01, 0.4495)) / (6.469 + Double.pow(r01, 0.4495))
        let β1g01: Double = (6.469 + 6.362 * Double.pow(g01, 0.4495)) / (6.469 + Double.pow(g01, 0.4495))
        let β2b01: Double = (8.414 + 8.091 * Double.pow(b01, 0.5128)) / (8.414 + Double.pow(b01, 0.5128)) * 0.7844
        let β1r02: Double = (6.469 + 6.362 * Double.pow(r02, 0.4495)) / (6.469 + Double.pow(r02, 0.4495))
        let β1g02: Double = (6.469 + 6.362 * Double.pow(g02, 0.4495)) / (6.469 + Double.pow(g02, 0.4495))
        let β2b02: Double = (8.414 + 8.091 * Double.pow(b02, 0.5128)) / (8.414 + Double.pow(b02, 0.5128)) * 0.7844
        
        // Step 2 - Note 4: Calculate the coefficient k.
        let n: Double = 1
        let K1: Double = Double.pow((yTristimulusPercentage * 100 * ξ1 + n) / (20 * ξ1 + n), (2 / 3) * β1r01)
        let K2: Double = Double.pow((yTristimulusPercentage * 100 * ξ2 + n) / (20 * ξ2 + n), (2 / 3) * β1r02)
        let K3: Double = Double.pow((yTristimulusPercentage * 100 * η1 + n) / (20 * η1 + n), (1 / 3) * β1g01)
        let K4: Double = Double.pow((yTristimulusPercentage * 100 * η2 + n) / (20 * η2 + n), (1 / 3) * β1g02)
        let K: Double = (K1 / K2) * (K3 / K4)
        
        // Step 2 - Finish calculation
        let R2: Double = (yTristimulusPercentage * 100 * ξ2 + n) *
            Double.pow(K, 1 / β1r02) *
            Double.pow((R1 + n) / (yTristimulusPercentage * 100 * ξ1 + n), β1r01 / β1r02)
            - n
        let G2: Double = (yTristimulusPercentage * 100 * η2 + n) *
            Double.pow(K, 1 / β1g02) *
            Double.pow((G1 + n) / (yTristimulusPercentage * 100 * η1 + n), β1g01 / β1g02)
            - n
        let B2: Double = (yTristimulusPercentage * 100 * ζ2 + n) *
            Double.pow(K, 1 / β2b02) *
            Double.pow((B1 + n) / (yTristimulusPercentage * 100 * ζ1 + n), β2b01 / β2b02)
            - n
        
        // Step 3 - Transform the values in the primary system back into tristimulus values.
        let X2 = 1.85995 * R2 - 1.12939 * G2 + 0.21990 * B2
        let Y2 = 0.36119 * R2 + 0.63881 * G2
        let Z2 = 1.08906 * B2
        
        return XyzColor(
            x: X2 / 100,
            y: Y2 / 100,
            z: Z2 / 100,
            opacity: xyzColor.opacity,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: self.referenceIlluminant))
        )
    }
    
    private func transformedRelativeChromacityCoordinates(from coordinate: XyChromaticityCoordinate) -> (ξ: Double, η: Double, ζ: Double) {
        let ξ = (0.48105 * coordinate.x + 0.78841 * coordinate.y - 0.08081) / coordinate.y
        let η = (-0.27200 * coordinate.x + 1.11962 * coordinate.y + 0.04570) / coordinate.y
        let ζ = (0.91822 * (1 - coordinate.x - coordinate.y)) / coordinate.y
        
        return (ξ, η, ζ)
    }
    
}
