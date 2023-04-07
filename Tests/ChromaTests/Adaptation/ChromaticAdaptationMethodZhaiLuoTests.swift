//
//  ChromaticAdaptationMethodZhaiLuoTests.swift
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
@testable import Chroma

class ChromaticAdaptationMethodZhaiLuoTests: XCTestCase {
    
    /// Tests the first example in the spec document.
    func testExample1Cat02() throws {
        let adaptationMethod = ChromaticAdaptationMethodZhaiLuo(
            testIlluminantDegreeOfAdaptation: 0.9407,
            referenceIlluminant: .TwoDegree.d65,
            referenceIlluminantDegreeOfAdaptation: 0.98,
            baselineIlluminant: StandardIlluminant(
                name: "",
                group: "",
                details: "",
                coordinate: XyyColor(XyzColor(x: 1, y: 1, z: 1))!.chromaticityCoordinate
            ),
            adaptationTransform: .cat02
        )
        
        let testColor = XyzColor(
            x: 0.489,
            y: 0.4362,
            z: 0.0625,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.a))
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.39186, accuracy: 0.0001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.42155, accuracy: 0.0001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.19237, accuracy: 0.0001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests the first example in the spec document.
    func testExample1Cat16() throws {
        let adaptationMethod = ChromaticAdaptationMethodZhaiLuo(
            testIlluminantDegreeOfAdaptation: 0.9407,
            referenceIlluminant: .TwoDegree.d65,
            referenceIlluminantDegreeOfAdaptation: 0.98,
            baselineIlluminant: StandardIlluminant(
                name: "",
                group: "",
                details: "",
                coordinate: XyyColor(XyzColor(x: 1, y: 1, z: 1))!.chromaticityCoordinate
            ),
            adaptationTransform: .cat16
        )
        
        let testColor = XyzColor(
            x: 0.489,
            y: 0.4362,
            z: 0.0625,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.a))
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.40374, accuracy: 0.0001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.43694, accuracy: 0.0001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.20517, accuracy: 0.0001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests the second example in the spec document.
    func testExample2Cat02() throws {
        let adaptationMethod = ChromaticAdaptationMethodZhaiLuo(
            testIlluminantDegreeOfAdaptation: 0.6709,
            referenceIlluminant: StandardIlluminant(
                name: "",
                group: "",
                details: "",
                coordinate: XyyColor(XyzColor(x: 1.05432, y: 1, z: 1.37392))!.chromaticityCoordinate
            ),
            referenceIlluminantDegreeOfAdaptation: 0.5331,
            baselineIlluminant: StandardIlluminant(
                name: "",
                group: "",
                details: "",
                coordinate: XyyColor(XyzColor(x: 0.97079, y: 1, z: 1.41798))!.chromaticityCoordinate
            ),
            adaptationTransform: .cat02
        )
        
        let testColor = XyzColor(
            x: 0.52034,
            y: 0.58824,
            z: 0.23703,
            opacity: 1.0,
            colorSpace: XyzColorSpace(
                profile: XyzColorSpace.Profile(
                    referenceWhite: StandardIlluminant(
                        name: "",
                        group: "",
                        details: "",
                        coordinate: XyyColor(XyzColor(x: 0.92288, y: 1, z: 0.38775))!.chromaticityCoordinate
                    )
                )
            )
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.57032, accuracy: 0.00001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.58934, accuracy: 0.00001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.64763, accuracy: 0.00001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite,
                       StandardIlluminant(
                        name: "",
                        group: "",
                        details: "",
                        coordinate: XyyColor(XyzColor(x: 1.05432, y: 1, z: 1.37392))!.chromaticityCoordinate
                       )
        )
    }
    
    /// Tests the second example in the spec document.
    func testExample2Cat16() throws {
        let adaptationMethod = ChromaticAdaptationMethodZhaiLuo(
            testIlluminantDegreeOfAdaptation: 0.6709,
            referenceIlluminant: StandardIlluminant(
                name: "",
                group: "",
                details: "",
                coordinate: XyyColor(XyzColor(x: 1.05432, y: 1, z: 1.37392))!.chromaticityCoordinate
            ),
            referenceIlluminantDegreeOfAdaptation: 0.5331,
            baselineIlluminant: StandardIlluminant(
                name: "",
                group: "",
                details: "",
                coordinate: XyyColor(XyzColor(x: 0.97079, y: 1, z: 1.41798))!.chromaticityCoordinate
            ),
            adaptationTransform: .cat16
        )
        
        let testColor = XyzColor(
            x: 0.52034,
            y: 0.58824,
            z: 0.23703,
            opacity: 1.0,
            colorSpace: XyzColorSpace(
                profile: XyzColorSpace.Profile(
                    referenceWhite: StandardIlluminant(
                        name: "",
                        group: "",
                        details: "",
                        coordinate: XyyColor(XyzColor(x: 0.92288, y: 1, z: 0.38775))!.chromaticityCoordinate
                    )
                )
            )
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.56771, accuracy: 0.00001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.58813, accuracy: 0.00001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.64669, accuracy: 0.00001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite,
                       StandardIlluminant(
                        name: "",
                        group: "",
                        details: "",
                        coordinate: XyyColor(XyzColor(x: 1.05432, y: 1, z: 1.37392))!.chromaticityCoordinate
                       )
        )
    }
    
}

