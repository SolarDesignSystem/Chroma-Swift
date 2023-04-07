//
//  ChromaticAdaptationTransformTests.swift
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

import XCTest
import Matrix
@testable import Chroma

class ChromaticAdaptationTransformTests: XCTestCase {
    
    func testTransformationMatrices() throws {
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.xyz.adaptationMatrix, Matrix(identityOfSize: 3), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.vonKries.adaptationMatrix, Matrix(
            elements: [
                0.4002400, 0.7076000, -0.0808100,
                -0.2263000, 1.1653200, 0.0457000,
                0.0000000, 0.0000000, 0.9182200
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.bradford.adaptationMatrix, Matrix(
            elements: [
                0.8951000, 0.2664000, -0.1614000,
                -0.7502000, 1.7135000, 0.0367000,
                0.0389000, -0.0685000, 1.0296000
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.sharp.adaptationMatrix,  Matrix(
            elements: [
                1.2694, 0.0988, -0.1706,
                -0.8364, 1.8006, 0.0357,
                0.0297, -0.0315, 1.0018
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.hunterPointerEsteves.adaptationMatrix, Matrix(
            elements: [
                0.3897, 0.6890, -0.0787,
                -0.2298, 1.1834, 0.0464,
                0.0, 0.0, 1.0
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.thorntons.adaptationMatrix, Matrix(
            elements: [
                1.8818, 0.4094, 0.3482,
                -0.8130, 1.6431, 0.1190,
                0.0198, -0.0405, 0.9382
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.cmcCat97.adaptationMatrix, Matrix(
            elements: [
                0.8951, -0.7502, 0.0389,
                0.2664, 1.7135, 0.0685,
                -0.1614, 0.0367, 1.0296
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.cmcCat2000.adaptationMatrix, Matrix(
            elements: [
                0.7982, 0.3389, -0.1371,
                -0.5918, 1.5512, 0.0406,
                0.0008, 0.0239, 0.9753
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.cat02.adaptationMatrix, Matrix(
            elements: [
                0.7328, 0.4296, -0.1624,
                -0.7036, 1.6975, 0.0061,
                0.0030, 0.0136, 0.9834
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.cat02Corrected.adaptationMatrix, Matrix(
            elements: [
                0.7328, 0.4296, -0.1624,
                -0.7036, 1.6975, 0.0061,
                0.0000, 0.0000, 1.0000
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.cat16.adaptationMatrix, Matrix(
            elements: [
                0.401288, 0.650173, -0.051461,
                -0.250268, 1.204414, 0.045854,
                -0.002079, 0.048952, 0.953127
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.biancoSchettini.adaptationMatrix, Matrix(
            elements: [
                0.8752, 0.2787, -0.1539,
                -0.8904, 1.8709, 0.0195,
                -0.0061, 0.0162, 0.9899
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.biancoSchettiniWithPositivityConstraint.adaptationMatrix, Matrix(
            elements: [
                0.6489, 0.3915, -0.0404,
                -0.3775, 1.3055, 0.0720,
                -0.0271, 0.0888, 0.0888
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
        XCTAssertEqual(ChromaticAdaptationMethodLinear.Transform.custom(Matrix(
            elements: [
                0.6489, 0.3915, -0.0404,
                -0.3775, 1.3055, 0.0720,
                -0.0271, 0.0888, 0.0888
            ],
            rowCount: 3,
            columnCount: 3
        )).adaptationMatrix, Matrix(
            elements: [
                0.6489, 0.3915, -0.0404,
                -0.3775, 1.3055, 0.0720,
                -0.0271, 0.0888, 0.0888
            ],
            rowCount: 3,
            columnCount: 3
        ), accuracy: 0.0000001, "The chromatic adaptation matrix does not match the expected value.")
    }
    
}
