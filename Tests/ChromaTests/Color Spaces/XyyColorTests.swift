//
//  XyyColorTests.swift
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

class XyyColorSpaceTests: XCTestCase {
    
    func testHash() throws {
        let hash = XyyColorSpace().hashValue
        XCTAssertNotNil(hash)
    }
    
    func testEquals() throws {
        XCTAssertTrue(XyyColorSpace() == XyyColorSpace())
        XCTAssertTrue(XyyColorSpace() != XyyColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.e)))
    }
    
}

class XyyColorTests: XCTestCase {

    func testComponents() throws {
        let color = XyyColor(x: 0.25, y: 0.5, luminance: 0.75)
        XCTAssertEqual(color.components, [0.25, 0.5, 0.75], "The XYy color's components do not match the expected value.")
    }
    
    func testInitWithColor() throws {
        let xyzColor = XyzColor(x: 0.25, y: 0.5, z: 0.75)
        let xyyColor = XyyColor(xyzColor)
        
        XCTAssertNotNil(xyyColor)
        XCTAssertEqual(xyyColor!.x, 0.166667, accuracy: 0.000001, "The x value of the color does not match the expected value.")
        XCTAssertEqual(xyyColor!.y, 0.333333, accuracy: 0.000001, "The y value of the color does not match the expected value.")
        XCTAssertEqual(xyyColor!.luminance, 0.500000, accuracy: 0.000001, "The luminance value of the color does not match the expected value.")
        XCTAssertEqual(xyyColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    func testInitWithColorWithColorSpace() throws {
        let d50 = XyzColor(x: 0.11627, y: 0.07261, z: 0.23256, colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d50)))
        let xyyColor = XyyColor(d50, colorSpace: XyyColorSpace(parent: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65))))
        
        XCTAssertNotNil(xyyColor)
        XCTAssertEqual(xyyColor!.x, 0.244163, accuracy: 0.0001, "The x value of the color does not match the expected value.")
        XCTAssertEqual(xyyColor!.y, 0.147387, accuracy: 0.0001, "The y value of the color does not match the expected value.")
        XCTAssertEqual(xyyColor!.luminance, 0.074930, accuracy: 0.0001, "The luminance value of the color does not match the expected value.")
        XCTAssertEqual(xyyColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    func testInitWithZeroColor() throws {
        let xyzColor = XyzColor(x: 0, y: 0, z: 0)
        let xyyColor = XyyColor(xyzColor)
        
        XCTAssertNil(xyyColor)
    }
    
    func testToXyzColor() throws {
        let xyyColor = XyyColor(x: 0.166667, y: 0.333333, luminance: 0.500000)
        let xyzColor = xyyColor.toXyzColor()
        
        XCTAssertNotNil(xyzColor)
        XCTAssertEqual(xyzColor!.x, 0.25, accuracy: 0.000001, "The X value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.y, 0.5, accuracy: 0.000001, "The Y value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.z, 0.75, accuracy: 0.000001, "The Z value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    func testToXyzColorWithZeroY () throws {
        let xyyColor = XyyColor(x: 0.166667, y: 0, luminance: 0.500000)
        let xyzColor = xyyColor.toXyzColor()
        
        XCTAssertNil(xyzColor)
    }
    
    func testUsingWithZeroY () throws {
        let xyyColor = XyyColor(x: 0.166667, y: 0, luminance: 0.500000)
        let xyzColor: XyzColor? = xyyColor.using(XyzColorSpace())
        
        XCTAssertNil(xyzColor)
    }
    
    func testToParent() throws {
        let xyyColor = XyyColor(x: 0.166667, y: 0.333333, luminance: 0.500000)
        let xyzColor = xyyColor.toParent()
        
        XCTAssertNotNil(xyzColor)
        XCTAssertEqual(xyzColor!.x, 0.25, accuracy: 0.000001, "The X value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.y, 0.5, accuracy: 0.000001, "The Y value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.z, 0.75, accuracy: 0.000001, "The Z value of the color does not match the expected value.")
        XCTAssertEqual(xyzColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    func testHash() throws {
        let hash = XyyColor(x: 1, y: 1, luminance: 1).hashValue
        XCTAssertNotNil(hash)
    }
    
}

class XyChromacityCoordinateTests: XCTestCase {
    
    func testZ() throws {
        let color = XyChromaticityCoordinate(x: 0.25, y: 0.5)
        XCTAssertEqual(color.z, 0.25, "The coordinate's z property does not match the expected value.")
    }
    
    func testInitWithTristimulus() throws {
        let color = XyChromaticityCoordinate(tristimulusX: 0.25, y: 0.5, z: 0.75)
        XCTAssertEqual(color.x, 0.166666, accuracy: 0.000001, "The X value of the coordinate does not match the expected value.")
        XCTAssertEqual(color.y, 0.333333, accuracy: 0.000001, "The Y value of the coordinate does not match the expected value.")
    }
    
}
