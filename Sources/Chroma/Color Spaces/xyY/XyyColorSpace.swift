//
//  XyyColorSpace.swift
//  Chroma
//
//  Created by Solar Design System on 12/19/21
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

/**
 The CIE 1931 xyY  color space: a three component, device independent color space based on the XYZ color space.
 
 *References*
 - [Wikipedia](http://en.wikipedia.org/wiki/CIE_1931_color_space)
 */
public final class XyyColorSpace: AlternativeColorSpace {
    
    // MARK: - Properties
    
    public let model: ColorModel = ColorModel(name: "xyY", components: [
        ColorModel.Component(name: "x", abbreviation: "x", description: ""),
        ColorModel.Component(name: "y", abbreviation: "y", description: ""),
        ColorModel.Component(name: "Luminance", abbreviation: "Y", description: ""),
    ])
    
    public var profile: XyzColorSpace.Profile {
        parent.profile
    }
    
    public var parent: XyzColorSpace
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(profile: XyzColorSpace.Profile(referenceWhite: StandardIlluminant.TwoDegree.d65))
    }
    
    public convenience init(profile: XyzColorSpace.Profile) {
        self.init(parent: XyzColorSpace(profile: profile))
    }
    
    public init(parent: XyzColorSpace) {
        self.parent = parent
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
        hasher.combine(parent)
    }
    
    public static func ==(lhs: XyyColorSpace, rhs: XyyColorSpace) -> Bool {
        lhs.parent == rhs.parent
    }
    
}
