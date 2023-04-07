//
//  OkLabColorTests.swift
//  Chroma
//
//  Created by Solar Design System on 12/31/21
//  Copyright (c) 2021 Solar Design System
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

class OkLabColorTests: XCTestCase {
    
    /// Tests converting an example color from XYZ to OkLab.
    func testFromXyzColor1() throws {
        let testColor = XyzColor(
            x: 0.950,
            y: 1.000,
            z: 1.089,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let labColor = OkLabColor(testColor)
        
        XCTAssertEqual(labColor!.lightness, 1.0, accuracy: 0.001, "The lightness value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.a, 0.0, accuracy: 0.001, "The a value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.b, 0.0, accuracy: 0.001, "The b value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests converting an example color from XYZ to OkLab.
    func testFromXyzColor2() throws {
        let testColor = XyzColor(
            x: 1.000,
            y: 0.000,
            z: 0.000,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let labColor = OkLabColor(testColor)
        
        XCTAssertEqual(labColor!.lightness, 0.450, accuracy: 0.001, "The lightness value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.a, 1.236, accuracy: 0.001, "The a value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.b, -0.019, accuracy: 0.001, "The b value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests converting an example color from XYZ to OkLab.
    func testFromXyzColor3() throws {
        let testColor = XyzColor(
            x: 0.000,
            y: 1.000,
            z: 0.000,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let labColor = OkLabColor(testColor)
        
        XCTAssertEqual(labColor!.lightness, 0.922, accuracy: 0.001, "The lightness value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.a, -0.671, accuracy: 0.001, "The a value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.b, 0.263, accuracy: 0.001, "The b value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests converting an example color from XYZ to OkLab.
    func testFromOkLabColor1() throws {
        let testColor = OkLabColor(
            lightness: 1,
            a: 0,
            b: 0,
            opacity: 1.0,
            colorSpace: OkLabColorSpace()
        )
        let xyzColor = testColor.toXyzColor()
        
        XCTAssertEqual(xyzColor!.x, 0.950, accuracy: 0.001, "The x value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.y, 1.000, accuracy: 0.001, "The y value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.z, 1.089, accuracy: 0.001, "The z value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
}

