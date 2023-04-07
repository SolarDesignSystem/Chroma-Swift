//
//  HslColorTests.swift
//  Chroma
//
//  Created by Solar Design System on 12/31/21
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

class HslColorTests: XCTestCase {
    
    /// Tests converting an example color from RGB to CMYK.
    func testFromRgbColor1() throws {
        let testColor = RgbColor(
            red: 142.0 / 255.0,
            green: 229.0 / 255.0,
            blue: 238.0 / 255.0,
            opacity: 1.0,
            colorSpace: .sRgb
        )
        let hsvColor = HslColor(testColor)
        
        XCTAssertEqual(hsvColor.hue, 3.23976, accuracy: 0.0001, "The hue value of the color does not match the expected value.")
        XCTAssertEqual(hsvColor.saturation, 0.738461, accuracy: 0.0001, "The saturation value of the color does not match the expected value.")
        XCTAssertEqual(hsvColor.lightness, 0.7450980, accuracy: 0.0001, "The lightness value of the color does not match the expected value.")
        XCTAssertEqual(hsvColor.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
    /// Tests converting an example color from Lab to XYZ.
    func testToRgbColor1() throws {
        let testColor = HslColor(
            hue: 3.23976,
            saturation: 0.738461,
            lightness: 0.7450980,
            opacity: 1.0,
            colorSpace: HslColorSpace()
        )
        let rgbColor = testColor.toParent()
        
        XCTAssertEqual(rgbColor!.red, 142.0 / 255.0, accuracy: 0.0001, "The red value of the color does not match the expected value.")
        XCTAssertEqual(rgbColor!.green, 229.0 / 255.0, accuracy: 0.0001, "The green value of the color does not match the expected value.")
        XCTAssertEqual(rgbColor!.blue, 238.0 / 255.0, accuracy: 0.0001, "The blue value of the color does not match the expected value.")
        XCTAssertEqual(rgbColor!.colorSpace.profile.referenceWhite, StandardIlluminant.TwoDegree.d65)
    }
    
}

