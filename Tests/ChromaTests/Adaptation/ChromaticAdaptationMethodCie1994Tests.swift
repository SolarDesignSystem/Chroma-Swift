//
//  ChromaticAdaptationMethodCie1994Tests.swift
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
@testable import Chroma

class ChromaticAdaptationMethodCie1994Tests: XCTestCase {

    /// Tests the first example in the spec document.
    func testExample1() throws {
        let adaptationMethod = ChromaticAdaptationMethodCie1994(testIlluminance: 1000, referenceIlluminant: .TwoDegree.d65, referenceIlluminance: 1000, yTristimulusPercentage: 0.20)
        
        let testColor = XyzColor(
            x: 0.28,
            y: 0.2126,
            z: 0.0527,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.a))
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.2403, accuracy: 0.0001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.2116, accuracy: 0.0001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.1764, accuracy: 0.0001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests the second example in the spec document.
    func testExample2() throws {
        let adaptationMethod = ChromaticAdaptationMethodCie1994(testIlluminance: 100, referenceIlluminant: .TwoDegree.d65, referenceIlluminance: 1000, yTristimulusPercentage: 0.50)
        
        let testColor = XyzColor(
            x: 0.2177,
            y: 0.1918,
            z: 0.1673,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let referenceColor = adaptationMethod(testColor)
        
        XCTAssertEqual(referenceColor.x, 0.2113, accuracy: 0.0001, "The X value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.y, 0.1943, accuracy: 0.0001, "The Y value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.z, 0.1950, accuracy: 0.0001, "The Z value of the reference color does not match the expected value.")
        XCTAssertEqual(referenceColor.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }

}
