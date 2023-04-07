//
//  JchColorTests.swift
//  Chroma
//
//  Created by Solar Design System on 12/26/21
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

class JchColorTests: XCTestCase {
    
    /// Tests converting an example color from XYZ to Lab.
    func testFromXyzColor1() throws {
        let testColor = XyzColor(
            x: 0.20654008,
            y: 0.12197225,
            z: 0.05136952,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let jabColor = JchColor(testColor)
        
        XCTAssertEqual(jabColor!.lightness, 0.00535048, accuracy: 0.0001, "The lightness value of the color does not match the expected value.")
        XCTAssertEqual(jabColor!.chroma, 0.0106349296, accuracy: 0.0001, "The chroma value of the color does not match the expected value.")
        XCTAssertEqual(jabColor!.hue, 0.5173784272, accuracy: 0.0001, "The hue value of the color does not match the expected value.")
        XCTAssertEqual(jabColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests converting an example color from Lab to XYZ.
    func testToXyzColor1() throws {
        let testColor = JchColor(
            lightness: 0.00535048,
            chroma: 0.0106349296,
            hue: 0.5173784272,
            opacity: 1.0,
            colorSpace: JchColorSpace()
        )
        let xyzColor = testColor.toXyzColor()
        
        XCTAssertEqual(xyzColor!.x, 0.20654008, accuracy: 0.0001, "The X value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.y, 0.12197225, accuracy: 0.0001, "The Y value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.z, 0.05136952, accuracy: 0.0001, "The Z value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
}

