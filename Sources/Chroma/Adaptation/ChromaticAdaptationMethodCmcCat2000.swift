//
//  ChromaticAdaptationMethodCmcCat2000.swift
//  Chroma
//
//  Created by Solar Design System on 12/20/21
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

///  Adapts colors from one environment to another using the CMC CAT 2000 chromatic adaptation method.
/// *References*
/// - CMC 2000 Chromatic Adaptation Transform: CMCCAT2000. Changjun Li, M. Ronnier Luo, Bryan Rigg, Robert W. G. Hunt. doi: 10.1002/col.10005
public struct ChromaticAdaptationMethodCmcCat2000: ChromaticAdaptationMethod {
    
    // MARK: - Types
    
    /// The viewing conditions of the samples.
    public enum ViewingCondition {
        
        // MARK: - Cases
        
        case average
        case dim
        case dark
        
        // MARK: - Properties
        
        /// The scale of the degree of adaptation.
        var F: Double {
            switch self {
            case .average:
                return 1
            case .dim:
                return 0.8
            case .dark:
                return 0.8
            }
        }
        
    }
    
    // MARK: - Properties
    
    /// The chromaticity coordinates of reference illuminant and background.
    var referenceIlluminant: StandardIlluminant
    
    /// The illuminance of the test adapting field. (cd/m^2)
    var testIlluminance: Double
    
    /// The illuminance of the reference adapting field. (cd/m^2)
    var referenceIlluminance: Double
    
    /// The viewing conditions of the samples.
    var viewingCondition: ViewingCondition
    
    // MARK: - Initialization
    
    /// Create a new adaptation.
    /// - Parameters:
    ///   - testIlluminance: The test illuminance. (lux)
    ///   - referenceIlluminant: The chromaticity coordinates of reference illuminant and background.
    ///   - referenceIlluminance: The reference illuminance. (lux)
    ///   - viewingCondition: The viewing conditions of the samples.
    public init(testIlluminance: Double, referenceIlluminant: StandardIlluminant, referenceIlluminance: Double, viewingCondition: ViewingCondition) {
        self.testIlluminance = testIlluminance
        self.referenceIlluminant = referenceIlluminant
        self.referenceIlluminance = referenceIlluminance
        self.viewingCondition = viewingCondition
    }
    
    // MARK: - Adaptation
    
    public func callAsFunction(_ xyzColor: XyzColor) -> XyzColor {
        
        // Symbol key:
        // (X, Y, Z)        = xyzColor
        // (Xw, Yw, Zw)     = testIlluminant
        // (Xwr, Ywr, Zwr)  = referenceIlluminant
        // (x02, y02)       = referenceIlluminant
        // LA1              = testIlluminance
        // LA2              = referenceIlluminance
        
        let testIlluminant = xyzColor.colorSpace.profile.referenceWhite.whitePoint.xyzTristimulus(withLuminosity: 100)
        let referenceIlluminant = self.referenceIlluminant.whitePoint.xyzTristimulus(withLuminosity: 100)
        
        // Step 1: Transform the necessary values into the fundamental primary system.
        let RGB = ChromaticAdaptationMethodLinear.Transform.cmcCat2000.adaptationMatrix * (100 * xyzColor.matrixForm)
        let RGBw = ChromaticAdaptationMethodLinear.Transform.cmcCat2000.adaptationMatrix * testIlluminant.matrixForm
        let RGBwr = ChromaticAdaptationMethodLinear.Transform.cmcCat2000.adaptationMatrix * referenceIlluminant.matrixForm
        
        // Step 2: Calculate the degree of adaptation.
        var D = viewingCondition.F * (
            0.08 *
            Double.log10(0.5 * (testIlluminance + referenceIlluminance)) +
            0.76 -
            0.45 *
            ((testIlluminance - referenceIlluminance) / (testIlluminance + referenceIlluminance))
        )
        D = min(max(D, 0), 1)
        
        // Step 3
        let α = D * (testIlluminant.y / referenceIlluminant.y)
        let Rc = RGB[0, 0] * (α * (RGBwr[0, 0] / RGBw[0, 0]) + 1 - D)
        let Gc = RGB[1, 0] * (α * (RGBwr[1, 0] / RGBw[1, 0]) + 1 - D)
        let Bc = RGB[2, 0] * (α * (RGBwr[2, 0] / RGBw[2, 0]) + 1 - D)
        
        // Step 4: Calculate the corresponding tristimulus values
        let XYZc = ChromaticAdaptationMethodLinear.Transform.cmcCat2000.adaptationMatrix.inverse * Matrix(elements: [Rc, Gc, Bc], rowCount: 3, columnCount: 1)
        
        return XyzColor(
            x: XYZc[0, 0] / 100,
            y: XYZc[1, 0] / 100,
            z: XYZc[2, 0] / 100,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: self.referenceIlluminant))
        )
        
    }
    
    
    
}
