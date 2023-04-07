//
//  LchAbColorTests.swift
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

class LchAbColorTests: XCTestCase {
    
    /// Tests converting an example color from Lab to LchAb.
    func testFromLabColor1() throws {
        let testColor = LabColor(
            luminance: 0.719738,
            a: 0.214481,
            b: 0.745288,
            opacity: 1.0,
            colorSpace: LabColorSpace(profile: LabColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let lchColor = LchAbColor(testColor)
        
        XCTAssertEqual(lchColor.luminance, 0.719738, accuracy: 0.0001, "The luminance value of the color does not match the expected value.")
        XCTAssertEqual(lchColor.chroma, 0.775536, accuracy: 0.0001, "The chroma value of the color does not match the expected value.")
        XCTAssertEqual(lchColor.hue, 1.290585, accuracy: 0.0001, "The hue value of the color does not match the expected value.")
        XCTAssertEqual(lchColor.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests converting an example color from Lab to XYZ.
    func testToLabColor1() throws {
        let testColor = LchAbColor(
            luminance: 0.719738,
            chroma: 0.775536,
            hue: 1.290585,
            opacity: 1.0,
            colorSpace: LchAbColorSpace(profile: LabColorSpace.Profile(referenceWhite: .TwoDegree.d65))
        )
        let labColor = testColor.toParent()
        
        XCTAssertEqual(labColor!.luminance, 0.719738, accuracy: 0.001, "The luminance value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.a, 0.214481, accuracy: 0.0001, "The a value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.b, 0.745288, accuracy: 0.0001, "The b value of the color does not match the expected value.")
        XCTAssertEqual(labColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
}

