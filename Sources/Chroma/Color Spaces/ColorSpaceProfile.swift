//
//  ColorSpaceProfile.swift
//  Chroma
//
//  Created by Solar Design System on 2023-02-10
//  Copyright (c) 2023 Solar Design System
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

/// Defines the necessary constants to define color spaces.
public protocol ColorSpaceProfile {
    
}

/// Defines the necessary constants to define color spaces mathematically in comparison to a reference white point.
public protocol ReferenceColorSpaceProfile: ColorSpaceProfile {
    
    // MARK: - Properties
    
    /// The reference white all colors are scaled to in the color space.
    var referenceWhite: StandardIlluminant { get }
    
    // MARK: - Initialization
    
    /**
     Creates a new color space profile.
     - parameter referenceWhite: The reference white all colors are scaled to in the color space.
    */
    init(referenceWhite: StandardIlluminant)
    
}
