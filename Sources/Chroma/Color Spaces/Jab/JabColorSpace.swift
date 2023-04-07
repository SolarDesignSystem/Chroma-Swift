//
//  JabColorSpace.swift
//  Chroma
//
//  Created by Solar Design System on 12/15/21
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
 Perceptually uniform color space for image signals including high dynamic range and wide gamut.
 
 *References*
 - Perceptually uniform color space for image signals including high dynamic range and wide gamut. Muhammad Safdar, Guihua Cui, Youn Jin Kim, Ming Ronnier Luo. doi: 10.1364/oe.25.015131
 */
public final class JabColorSpace: ReferenceColorSpace, Hashable {
    
    // MARK: - Profile
    
    /**
     Defines the necessary constants to define the color space mathematically.
     
     The colorspace uses the D65 white point with a 2° observer for all colors.
     */
    public struct Profile: ReferenceColorSpaceProfile, Hashable {
        
        // MARK: - Properties
        
        /// The reference white all colors are scaled to in the color space.
        public let referenceWhite: StandardIlluminant
        
        // MARK: - Initialization
        
        public init(referenceWhite: StandardIlluminant = .TwoDegree.d65) {
            self.referenceWhite = referenceWhite
        }
        
    }
    
    // MARK: - Properties
    
    public let model: ColorModel = ColorModel(name: "Jab", components: [
        ColorModel.Component(name: "lightness", abbreviation: "J", description: ""),
        ColorModel.Component(name: "redness-greenness", abbreviation: "a", description: ""),
        ColorModel.Component(name: "yellowness–blueness", abbreviation: "b", description: ""),
    ])
    
    public var profile: JabColorSpace.Profile
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(profile: Profile())
    }
    
    public init(profile: JabColorSpace.Profile) {
        self.profile = profile
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
        hasher.combine(profile)
    }
    
    public static func ==(lhs: JabColorSpace, rhs: JabColorSpace) -> Bool {
        lhs.profile == rhs.profile
    }
    
}
