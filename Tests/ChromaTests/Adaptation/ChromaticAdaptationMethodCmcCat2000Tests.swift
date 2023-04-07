//
//  ChromaticAdaptationMethodCmcCat2000Tests.swift
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

class ChromaticAdaptationMethodCmcCat2000Tests: XCTestCase {

    /// Tests the example in the spec document.
    func testAverageExample() throws {
        let adaptationMethod = ChromaticAdaptationMethodCmcCat2000(
            testIlluminance: 200,
            referenceIlluminant: .TenDegree.d65,
            referenceIlluminance: 200,
            viewingCondition: .average
        )
        
        let testColor = XyzColor(
            x: 0.2248,
            y: 0.2274,
            z: 0.0854,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TenDegree.a))
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.1953, accuracy: 0.0001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.2307, accuracy: 0.0001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.2497, accuracy: 0.0001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite, StandardIlluminant.TenDegree.d65)
    }
    
    func testDimExample() throws {
        let adaptationMethod = ChromaticAdaptationMethodCmcCat2000(
            testIlluminance: 200,
            referenceIlluminant: .TenDegree.d65,
            referenceIlluminance: 200,
            viewingCondition: .dim
        )
        
        let testColor = XyzColor(
            x: 0.2248,
            y: 0.2274,
            z: 0.0854,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TenDegree.a))
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.2011, accuracy: 0.0001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.2300, accuracy: 0.0001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.2168, accuracy: 0.0001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite, StandardIlluminant.TenDegree.d65)
    }
    
    func testDarkExample() throws {
        let adaptationMethod = ChromaticAdaptationMethodCmcCat2000(
            testIlluminance: 200,
            referenceIlluminant: .TenDegree.d65,
            referenceIlluminance: 200,
            viewingCondition: .dark
        )
        
        let testColor = XyzColor(
            x: 0.2248,
            y: 0.2274,
            z: 0.0854,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TenDegree.a))
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.2011, accuracy: 0.0001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.2300, accuracy: 0.0001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.2168, accuracy: 0.0001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite, StandardIlluminant.TenDegree.d65)
    }

}
