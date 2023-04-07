//
//  RgbColorTests.swift
//  Chroma
//
//  Created by Solar Design System on 02/11/22
//  Copyright (c) 2022 Solar Design System
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

class RgbColorSpaceTests: XCTestCase {
    
    func testHash() throws {
        let hash = RgbColorSpace().hashValue
        XCTAssertNotNil(hash)
    }
    
    func testEquals() throws {
        XCTAssertTrue(RgbColorSpace() == RgbColorSpace())
        XCTAssertTrue(RgbColorSpace() != RgbColorSpace(profile: RgbColorSpace.Profile(referenceWhite: .TwoDegree.e)))
    }
    
}

class RgbColorTests: XCTestCase {

    func testComponents() throws {
        let color = RgbColor(red: 0.25, green: 0.5, blue: 0.75)
        XCTAssertEqual(color.components, [0.25, 0.5, 0.75], "The RGB color's components do not match the expected value.")
    }
    
    func testInitWithColor() throws {
        let xyzColor = XyzColor(x: 0.20654008, y: 0.12197225, z: 0.05136952)
        let rgbColor = RgbColor(xyzColor)

        XCTAssertNotNil(rgbColor)
        XCTAssertEqual(rgbColor!.red, 0.70573936, accuracy: 0.0001, "The red value of the color does not match the expected value.")
        XCTAssertEqual(rgbColor!.green, 0.19248266, accuracy: 0.0002, "The green value of the color does not match the expected value.")
        XCTAssertEqual(rgbColor!.blue, 0.22354169, accuracy: 0.0001, "The blue value of the color does not match the expected value.")
        XCTAssertEqual(rgbColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }

    func testInitWithZeroColor() throws {
        let xyzColor = XyzColor(x: 0, y: 0, z: 0)
        let rgbColor = RgbColor(xyzColor)

        XCTAssertNotNil(rgbColor)
        XCTAssertEqual(rgbColor!.red, 0, accuracy: 0.0001, "The red value of the color does not match the expected value.")
        XCTAssertEqual(rgbColor!.green, 0, accuracy: 0.0002, "The green value of the color does not match the expected value.")
        XCTAssertEqual(rgbColor!.blue, 0, accuracy: 0.0001, "The blue value of the color does not match the expected value.")
    }

    func testToXyzColor() throws {
        let rgbColor = RgbColor(red: 0.70573936, green: 0.19248266, blue: 0.22354169)
        let xyzColor = rgbColor.toXyzColor()

        XCTAssertNotNil(xyzColor)
        XCTAssertEqual(xyzColor!.x, 0.20654008, accuracy: 0.0001, "The X value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.y, 0.12197225, accuracy: 0.0001, "The Y value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.z, 0.05136952, accuracy: 0.0001, "The Z value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    func testHash() throws {
        let hash = RgbColor(red: 1, green: 1, blue: 1).hashValue
        XCTAssertNotNil(hash)
    }
    
}
