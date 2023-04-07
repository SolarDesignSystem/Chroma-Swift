//
//  OkLabColorSpace.swift
//  Chroma
//
//  Created by Solar Design System on 12/31/21
//  Copyright © 2020 Brandon McQuilkin. All rights reserved.
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
 A perceptual color space built for image processing.
 
 *References*
 - [A perceptual color space for image processing. Björn Ottosson.](https://bottosson.github.io/posts/oklab/)
 */
public final class OkLabColorSpace: ReferenceColorSpace, Hashable {
    
    // MARK: - Profile
    
    /// Defines the necessary constants to define the color space mathematically.
    public struct Profile: ReferenceColorSpaceProfile, Hashable {

        // MARK: - Properties
        
        public var referenceWhite: StandardIlluminant
        
        // MARK: - Initialization
        
        public init(referenceWhite: StandardIlluminant = StandardIlluminant.TwoDegree.d65) {
            self.referenceWhite = referenceWhite
        }
        
    }
    
    // MARK: - Properties
    
    public let model: ColorModel = ColorModel(name: "OkLab", components: [
        ColorModel.Component(name: "lightness", abbreviation: "L", description: ""),
        ColorModel.Component(name: "green / red", abbreviation: "a", description: ""),
        ColorModel.Component(name: "blue / yellow", abbreviation: "b", description: ""),
    ])
    
    /// The numerical model of the color space.
    public let profile: Profile
    
    // MARK: - Initialization
    
    /// Creates a new OkLab color space using the D65 illuminant with a 2° observer.
    public convenience init() {
        self.init(profile: Profile())
    }
    
    /**
     Creates a new OkLab color space.
     - parameter profile: The profile used to mathematically define the color space.
     */
    public init(profile: Profile) {
        self.profile = profile
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
        hasher.combine(profile)
    }
    
    public static func ==(lhs: OkLabColorSpace, rhs: OkLabColorSpace) -> Bool {
        lhs.profile == rhs.profile
    }

}
