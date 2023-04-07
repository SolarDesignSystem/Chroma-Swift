//
//  ChromaticAdaptationMethodLinearTests.swift
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

import XCTest
import Matrix
@testable import Chroma

class ChromaticAdaptationMethodLinearTests: XCTestCase {

    /// Tests the generation of an adaptation matrix.
    func testAdaptationMatrix() throws {
        let matrix = ChromaticAdaptationMethodLinear.adaptationMatrix(forTestWhitePoint: StandardIlluminant.TwoDegree.a.whitePoint, referenceWhitePoint: StandardIlluminant.TwoDegree.d65.whitePoint, usingTransform: .bradford)
        XCTAssertEqual(
            matrix,
            Matrix(
                elements: [
                    0.8446965, -0.1179225, 0.3948108,
                    -0.1366303, 1.1041226, 0.1291718,
                    0.0798489, -0.1348999, 3.1924009
                ],
                rowCount: 3,
                columnCount: 3
            ),
            accuracy: 0.001,
            "The adaptation matrix does not match the expected value."
        )
    }
    
    /// Tests conversion of a color.
    func testExample() throws {
        let adaptationMethod = ChromaticAdaptationMethodLinear(adaptationTransform: .bradford, referenceIlluminant: .TwoDegree.d65)
        
        let testColor = XyzColor(
            x: 0.2248,
            y: 0.2274,
            z: 0.0854,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.a))
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.1967, accuracy: 0.0001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.2313, accuracy: 0.0001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.2599, accuracy: 0.0001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }

}

