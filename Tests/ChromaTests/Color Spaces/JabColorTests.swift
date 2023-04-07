//
//  JabColorTests.swift
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

class JabColorTests: XCTestCase {
    
    /// Tests converting an example color from XYZ to Lab.
    func testFromXyzColor1() throws {
        let testColor = XyzColor(
            x: 0.20654008,
            y: 0.12197225,
            z: 0.05136952,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let jabColor = JabColor(testColor)
        
        XCTAssertEqual(jabColor!.lightness, 0.00535048, accuracy: 0.0001, "The lightness value of the color does not match the expected value.")
        XCTAssertEqual(jabColor!.a, 0.00924302, accuracy: 0.0001, "The a value of the color does not match the expected value.")
        XCTAssertEqual(jabColor!.b, 0.00526007, accuracy: 0.0001, "The b value of the color does not match the expected value.")
        XCTAssertEqual(jabColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests converting an example color from Lab to XYZ.
    func testToXyzColor1() throws {
        let testColor = JabColor(
            lightness: 0.00535048,
            a: 0.00924302,
            b: 0.00526007,
            opacity: 1.0,
            colorSpace: JabColorSpace()
        )
        let xyzColor = testColor.toXyzColor()
        
        XCTAssertEqual(xyzColor!.x, 0.20654008, accuracy: 0.0001, "The X value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.y, 0.12197225, accuracy: 0.0001, "The Y value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.z, 0.05136952, accuracy: 0.0001, "The Z value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
}

