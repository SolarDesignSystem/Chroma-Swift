//
//  ColorTests.swift
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

class ColorTests: XCTestCase {

    func testUsing() throws {
        let d50 = XyzColor(x: 0.11627, y: 0.07261, z: 0.23256, colorSpace: XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d50)))
        let d65: XyzColor? = d50.using(XyzColorSpace(profile: XyzColorSpace.Profile(referenceWhite: .TwoDegree.d65)))
        
        XCTAssertEqual(d65!.x, 0.12413, accuracy: 0.0001, "The X value of the color does not match the expected value.")
        XCTAssertEqual(d65!.y, 0.07493, accuracy: 0.0001, "The Y value of the color does not match the expected value.")
        XCTAssertEqual(d65!.z, 0.30933, accuracy: 0.0001, "The Z value of the color does not match the expected value.")
        XCTAssertEqual(d65!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
}

