//
//  LabColorTests.swift
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

class LabColorTests: XCTestCase {
    
    /// Tests converting an example color from XYZ to Lab.
    func testFromXyzColor1() throws {
        let testColor = XyzColor(
            x: 0.489,
            y: 0.4362,
            z: 0.0625,
            opacity: 1.0,
            colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let labColor = LabColor(testColor)
        
        XCTAssertEqual(labColor!.luminance, 0.719738, accuracy: 0.0001, "The luminance value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.a, 0.214481, accuracy: 0.0001, "The a value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.b, 0.745288, accuracy: 0.0001, "The b value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests converting an example color from Lab to XYZ.
    func testToXyzColor1() throws {
        let testColor = LabColor(
            luminance: 0.719738,
            a: 0.214481,
            b: 0.745288,
            opacity: 1.0,
            colorSpace: LabColorSpace(profile: LabColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let xyzColor = testColor.toXyzColor()
        
        XCTAssertEqual(xyzColor!.x, 0.489, accuracy: 0.001, "The X value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.y, 0.4362, accuracy: 0.0001, "The Y value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.z, 0.0625, accuracy: 0.0001, "The Z value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
}

