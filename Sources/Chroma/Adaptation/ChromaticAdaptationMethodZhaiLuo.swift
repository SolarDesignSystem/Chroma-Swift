//
//  ChromaticAdaptationMethodZhaiLuo.swift
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

/// Adapts colors from one environment to another using a linear chromatic adaptation method.
///
/// *References*
/// - Study of chromatic adaptation via neutral white matches on different viewing media. Zhai, Qiyan; Luo, Ming R.  (2018). doi: 10.1364/oe.26.007724
public struct ChromaticAdaptationMethodZhaiLuo: ChromaticAdaptationMethod {
    
    // MARK: - Type
    
    /// Defines several chromatic adaptation matrices that can be used during chromatic adaptation.
    public enum AdaptationTransform {
        
        // MARK: - Cases
        
        /// CAT 02 chromatic adaptation transform.
        /// *Reference*
        /// - [Wikipedia](https://en.wikipedia.org/wiki/CIECAM02#CAT02)]
        case cat02
        
        /// CAT 16 chromatic adaptation transform.
        /// *Reference*
        /// - Comprehensive color solutions: CAM16, CAT16, and CAM16-UCS. Li, C., Li, Z., Wang, Z., Xu, Y., Luo, M. R., Cui, G., Melgosa, M., Brill, M. H., & Pointer, M. (2017). doi: 10.1002/col.22131
        case cat16
        
        // MARK: - Properties
        
        /// The adaptation matrix for the transform.
        public var adaptationMatrix: Matrix<Double> {
            switch self {
            case .cat02:
                return ChromaticAdaptationMethodLinear.Transform.cat02.adaptationMatrix
            case .cat16:
                return ChromaticAdaptationMethodLinear.Transform.cat16.adaptationMatrix
            }
        }
        
    }
    
    // MARK: - Properties
    
    /// The degree of adaptation of the test illuminant.
    var testIlluminantDegreeOfAdaptation: Double
    
    /// The chromaticity coordinates of reference illuminant and background.
    var referenceIlluminant: StandardIlluminant
    
    /// The degree of adaptation of the reference illuminant.
    var referenceIlluminantDegreeOfAdaptation: Double
    
    /// The chromaticity coordinates of baseline illuminant.
    var baselineIlluminant: StandardIlluminant
    
    /// The chromatic adaptation transform to use during chromatic adaptation.
    var adaptationTransform: AdaptationTransform
    
    // MARK: - Initialization
    
    /// Create a new adaptation.
    /// - Parameters:
    ///   - testIlluminantDegreeOfAdaptation: The degree of adaptation of the test illuminant.
    ///   - referenceIlluminant: The chromaticity coordinates of reference illuminant and background.
    ///   - referenceIlluminantDegreeOfAdaptation: The degree of adaptation of the reference illuminant.
    ///   - baselineIlluminant: The chromaticity coordinates of baseline illuminant.
    ///   - adaptationTransform: The chromatic adaptation transform to use during chromatic adaptation.
    public init(testIlluminantDegreeOfAdaptation: Double, referenceIlluminant: StandardIlluminant, referenceIlluminantDegreeOfAdaptation: Double, baselineIlluminant: StandardIlluminant, adaptationTransform: AdaptationTransform) {
        self.testIlluminantDegreeOfAdaptation = testIlluminantDegreeOfAdaptation
        self.referenceIlluminant = referenceIlluminant
        self.referenceIlluminantDegreeOfAdaptation = referenceIlluminantDegreeOfAdaptation
        self.baselineIlluminant = baselineIlluminant
        self.adaptationTransform = adaptationTransform
    }
    
    // MARK: - Adaptation
    
    public func callAsFunction(_ xyzColor: XyzColor) -> XyzColor {
        // Symbol key:
        // (Xβ, Yβ, Zβ)     = xyzColor
        // (Xwβ, Ywβ, Zwβ)  = testIlluminant
        // Dβ               = testIlluminantDegreeOfAdaptation
        // (Xwδ, Ywδ, Zwδ)  = referenceIlluminant
        // Dδ               = referenceIlluminantDegreeOfAdaptation
        // (Xwo, Ywo, Zwo)  = baselineIlluminant
        
        // Step 1: Calculate the cone like responses.
        let RGBβ = adaptationTransform.adaptationMatrix * xyzColor.matrixForm
        let RGBwβ = adaptationTransform.adaptationMatrix * xyzColor.colorSpace.profile.referenceWhite.whitePoint.xyzTristimulus().matrixForm
        let RGBwδ = adaptationTransform.adaptationMatrix * referenceIlluminant.whitePoint.xyzTristimulus().matrixForm
        let RGBwo = adaptationTransform.adaptationMatrix * baselineIlluminant.whitePoint.xyzTristimulus().matrixForm
        
        // Step 2: Calculate the scaling factors for each channel.
        let DRβ = testIlluminantDegreeOfAdaptation * (xyzColor.colorSpace.profile.referenceWhite.whitePoint.xyzTristimulus().y / baselineIlluminant.whitePoint.xyzTristimulus().y) * (RGBwo[0, 0] / RGBwβ[0, 0]) + 1 - testIlluminantDegreeOfAdaptation
        let DGβ = testIlluminantDegreeOfAdaptation * (xyzColor.colorSpace.profile.referenceWhite.whitePoint.xyzTristimulus().y / baselineIlluminant.whitePoint.xyzTristimulus().y) * (RGBwo[1, 0] / RGBwβ[1, 0]) + 1 - testIlluminantDegreeOfAdaptation
        let DBβ = testIlluminantDegreeOfAdaptation * (xyzColor.colorSpace.profile.referenceWhite.whitePoint.xyzTristimulus().y / baselineIlluminant.whitePoint.xyzTristimulus().y) * (RGBwo[2, 0] / RGBwβ[2, 0]) + 1 - testIlluminantDegreeOfAdaptation
        let DRδ = referenceIlluminantDegreeOfAdaptation * (referenceIlluminant.whitePoint.xyzTristimulus().y / baselineIlluminant.whitePoint.xyzTristimulus().y) * (RGBwo[0, 0] / RGBwδ[0, 0]) + 1 - referenceIlluminantDegreeOfAdaptation
        let DGδ = referenceIlluminantDegreeOfAdaptation * (referenceIlluminant.whitePoint.xyzTristimulus().y / baselineIlluminant.whitePoint.xyzTristimulus().y) * (RGBwo[1, 0] / RGBwδ[1, 0]) + 1 - referenceIlluminantDegreeOfAdaptation
        let DBδ = referenceIlluminantDegreeOfAdaptation * (referenceIlluminant.whitePoint.xyzTristimulus().y / baselineIlluminant.whitePoint.xyzTristimulus().y) * (RGBwo[2, 0] / RGBwδ[2, 0]) + 1 - referenceIlluminantDegreeOfAdaptation
        
        let DR = DRβ / DRδ
        let DG = DGβ / DGδ
        let DB = DBβ / DBδ
        
        // Step 3: Calculate the adaptations in cone-like space for each channel.
        let Rδ = DR * RGBβ[0, 0]
        let Gδ = DG * RGBβ[1, 0]
        let Bδ = DB * RGBβ[2, 0]
        
        // Step 4: Calculate the corresponding color under the output illuminant.
        let XYZδ = adaptationTransform.adaptationMatrix.inverse * Matrix(elements: [Rδ, Gδ, Bδ], rowCount: 3, columnCount: 1)
        
        return XyzColor(
            x: XYZδ[0, 0],
            y: XYZδ[1, 0],
            z: XYZδ[2, 0],
            opacity: xyzColor.opacity,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: referenceIlluminant))
        )
    }
    
}
