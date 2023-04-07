//
//  ChromaticAdaptationMethodLinear.swift
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
/// *References*
/// - [Bruce Lindbloom](http://www.brucelindbloom.com/index.html?Eqn_ChromAdapt.html)]
public struct ChromaticAdaptationMethodLinear: ChromaticAdaptationMethod {
    
    // MARK: - Properties
    
    /// The method to use to transform the test value into the reference space.
    var adaptationTransform: Transform
    
    /// The chromaticity coordinates of reference illuminant and background.
    var referenceIlluminant: StandardIlluminant
    
    // MARK: - Initialization
    
    /// Create a new adaptation.
    /// - Parameters:
    ///   - adaptationTransform: The method to use to transform the test value into the reference space.
    ///   - referenceIlluminant: The chromaticity coordinates of reference illuminant and background.
    public init(adaptationTransform: Transform, referenceIlluminant: StandardIlluminant) {
        self.adaptationTransform = adaptationTransform
        self.referenceIlluminant = referenceIlluminant
    }
    
    // MARK: - Adaptation
    
    /// The adaptation matrix for the transform.
    public static func adaptationMatrix(forTestWhitePoint testWhitePoint: XyChromaticityCoordinate, referenceWhitePoint: XyChromaticityCoordinate, usingTransform transform: Transform) -> Matrix<Double> {
        let sourceConeResponseDomain = transform.adaptationMatrix * testWhitePoint.xyzTristimulus().matrixForm
        let destinationConeResponseDomain = transform.adaptationMatrix * referenceWhitePoint.xyzTristimulus().matrixForm
        
        return transform.adaptationMatrix.inverse *
        Matrix(
            elements: [
                destinationConeResponseDomain[0, 0] / sourceConeResponseDomain[0, 0], 0, 0,
                0, destinationConeResponseDomain[1, 0] / sourceConeResponseDomain[1, 0], 0,
                0, 0, destinationConeResponseDomain[2, 0] / sourceConeResponseDomain[2, 0]
            ],
            rowCount: 3,
            columnCount: 3
        ) * transform.adaptationMatrix
    }
    
    public func callAsFunction(_ xyzColor: XyzColor) -> XyzColor {
        let transformationMatrix = ChromaticAdaptationMethodLinear.adaptationMatrix(
            forTestWhitePoint: xyzColor.colorSpace.profile.referenceWhite.whitePoint,
            referenceWhitePoint: referenceIlluminant.whitePoint,
            usingTransform: adaptationTransform
        )
        
        let destinationXyz = transformationMatrix * xyzColor.matrixForm
        
        return XyzColor(
            x: destinationXyz[0, 0],
            y: destinationXyz[1, 0],
            z: destinationXyz[2, 0],
            opacity: xyzColor.opacity,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: referenceIlluminant))
        )
    }
    
}

extension ChromaticAdaptationMethodLinear {
    
    /// Defines several chromatic adaptation matrices.
    public enum Transform {
        
        // MARK: Cases
        
        /**
         Linear XYZ Scaling chromatic adaptation transform.
         */
        case xyz
        
        /**
         Von Kries chromatic adaptation transform.
         
         *Reference*
         - [Lindbloom](http://brucelindbloom.com/Eqn_ChromAdapt.html)
         */
        case vonKries
        
        /**
         Bradford chromatic adaptation transform.
         
         *Reference*
         - [Lindbloom](http://brucelindbloom.com/Eqn_ChromAdapt.html)
         */
        case bradford
        
        /**
         Sharp chromatic adaptation transform.
         
         *Reference*
         - S. Bianco; R. Schettini (2010). Two new von Kries based chromatic adaptation transforms found by numerical optimization. doi: 10.1002/col.20573
         */
        case sharp
        
        /**
         Hunter Pointer Esteves chromatic adaptation transform.
         
         *Reference*
         - Applying Mixed Adaptation to VariousChromatic Adaptation Transformation(CAT) ModelsNaoya Katoh, Kiyotaka NakabayashiPNC Development Center, Sony Corporation, Tokyo, Japan
         */
        case hunterPointerEsteves
        
        /**
         Thorntons chromatic adaptation transform.
         
         *Reference*
         - Applying Mixed Adaptation to VariousChromatic Adaptation Transformation(CAT) Models, Naoya Katoh, Kiyotaka NakabayashiPNC Development Center, Sony Corporation, Tokyo, Japan
         */
        case thorntons
        
        /**
         CMC CAT 97 chromatic adaptation transform.
         
         *Reference*
         - Performance Of Five Chromatic Adaptation Transforms Using Large Number Of Color Patches,  Dejana Đorđević*, Aleš Hladnik, Andrej Javoršek
         */
        case cmcCat97
        
        /**
         CMC CAT 2000 chromatic adaptation transform.
         
         *Reference*
         - Performance Of Five Chromatic Adaptation Transforms Using Large Number Of Color Patches,  Dejana Đorđević*, Aleš Hladnik, Andrej Javoršek
         */
        case cmcCat2000
        
        /**
         CAT 02 chromatic adaptation transform.
         
         *Reference*
         - [Wikipedia](https://en.wikipedia.org/wiki/CIECAM02#CAT02)]
         */
        case cat02
        
        /**
         CAT 02 chromatic adaptation transform with the Brill & Susstrunk corrections.
         
         *Reference*
         - Repairing gamut problems in CIECAM02: A progress report. Brill, M. H., & Susstrunk, S. (2008). doi: 10.1002/col.20432
         */
        case cat02Corrected
        
        /**
         CAT 16 chromatic adaptation transform.
         
         *Reference*
         - Comprehensive color solutions: CAM16, CAT16, and CAM16-UCS. Li, C., Li, Z., Wang, Z., Xu, Y., Luo, M. R., Cui, G., Melgosa, M., Brill, M. H., & Pointer, M. (2017). doi: 10.1002/col.22131
         */
        case cat16
        
        /**
         Bianco-Schettini chromatic adaptation transform.
         
         *Reference*
         - Two New von Kries Based Chromatic Adaptation Transforms Found by Numerical Optimization. S. Bianco,* R. Schettini. doi: 10.1002/col.20573
         */
        case biancoSchettini
        
        /**
         Bianco-Schettini with positivity constraint chromatic adaptation transform.
         
         *Reference*
         - Two New von Kries Based Chromatic Adaptation Transforms Found by Numerical Optimization. S. Bianco,* R. Schettini. doi: 10.1002/col.20573
         */
        case biancoSchettiniWithPositivityConstraint
        
        /**
         A custom chromatic adaptation transform.
         */
        case custom(Matrix<Double>)
        
        // MARK: - Properties
        
        public var adaptationMatrix: Matrix<Double> {
            switch self {
            case .xyz:
                return Matrix(identityOfSize: 3)
            case .vonKries:
                return Matrix(
                    elements: [
                        0.4002400, 0.7076000, -0.0808100,
                        -0.2263000, 1.1653200, 0.0457000,
                        0.0000000, 0.0000000, 0.9182200
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .bradford:
                return Matrix(
                    elements: [
                        0.8951000, 0.2664000, -0.1614000,
                        -0.7502000, 1.7135000, 0.0367000,
                        0.0389000, -0.0685000, 1.0296000
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .sharp:
                return Matrix(
                    elements: [
                        1.2694, 0.0988, -0.1706,
                        -0.8364, 1.8006, 0.0357,
                        0.0297, -0.0315, 1.0018
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .hunterPointerEsteves:
                return Matrix(
                    elements: [
                        0.3897, 0.6890, -0.0787,
                        -0.2298, 1.1834, 0.0464,
                        0.0, 0.0, 1.0
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .thorntons:
                return Matrix(
                    elements: [
                        1.8818, 0.4094, 0.3482,
                        -0.8130, 1.6431, 0.1190,
                        0.0198, -0.0405, 0.9382
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .cmcCat97:
                return Matrix(
                    elements: [
                        0.8951, -0.7502, 0.0389,
                        0.2664, 1.7135, 0.0685,
                        -0.1614, 0.0367, 1.0296
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .cmcCat2000:
                return Matrix(
                    elements: [
                        0.7982, 0.3389, -0.1371,
                        -0.5918, 1.5512, 0.0406,
                        0.0008, 0.0239, 0.9753
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .cat02:
                return Matrix(
                    elements: [
                        0.7328, 0.4296, -0.1624,
                        -0.7036, 1.6975, 0.0061,
                        0.0030, 0.0136, 0.9834
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .cat02Corrected:
                return Matrix(
                    elements: [
                        0.7328, 0.4296, -0.1624,
                        -0.7036, 1.6975, 0.0061,
                        0.0000, 0.0000, 1.0000
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .cat16:
                return Matrix(
                    elements: [
                        0.401288, 0.650173, -0.051461,
                        -0.250268, 1.204414, 0.045854,
                        -0.002079, 0.048952, 0.953127
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .biancoSchettini:
                return Matrix(
                    elements: [
                        0.8752, 0.2787, -0.1539,
                        -0.8904, 1.8709, 0.0195,
                        -0.0061, 0.0162, 0.9899
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case .biancoSchettiniWithPositivityConstraint:
                return Matrix(
                    elements: [
                        0.6489, 0.3915, -0.0404,
                        -0.3775, 1.3055, 0.0720,
                        -0.0271, 0.0888, 0.0888
                    ],
                    rowCount: 3,
                    columnCount: 3
                )
            case let .custom(matrix):
                return matrix
            }
        }
        
    }
    
}
