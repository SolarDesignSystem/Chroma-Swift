//
//  LabColorSpace.swift
//  Chroma
//
//  Created by Solar Design System on 6/6/20
//  Copyright © 2020 Solar Design System. All rights reserved.
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
 The CIE 1976 L\*a\*b\* color space.
 
 *References*
 - [Bruce Lindbloom](http://www.brucelindbloom.com/index.html?Eqn_XYZ_to_Lab.html)
 - CIE 15: Technical Report: Colorimetry, 3rd edition. International Commission on Illumination. ISBN: 978-3-901906-33-6
 */
public final class LabColorSpace: ReferenceColorSpace, Hashable {
    
    // MARK: - Profile
    
    /// Defines the necessary constants to define the color space mathematically.
    public struct Profile: ReferenceColorSpaceProfile, Hashable {
        
        // MARK: - Properties
        
        public var referenceWhite: StandardIlluminant
        
        // MARK: - Initialization
        
        public init(referenceWhite: StandardIlluminant) {
            self.referenceWhite = referenceWhite
        }
        
    }
    
    // MARK: - Properties
    
    public let model: ColorModel = ColorModel(name: "Lab", components: [
        ColorModel.Component(name: "luminance", abbreviation: "L", description: ""),
        ColorModel.Component(name: "a", abbreviation: "a", description: ""),
        ColorModel.Component(name: "b", abbreviation: "b", description: ""),
    ])
    
    /// The numerical model of the color space.
    public let profile: Profile
    
    // MARK: - Initialization
    
    /// Creates a new Lab color space using the D65 illuminant with a 2° observer.
    public convenience init() {
        self.init(profile: Profile(referenceWhite: StandardIlluminant.TwoDegree.d65))
    }
    
    /**
     Creates a new Lab color space.
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
    
    public static func ==(lhs: LabColorSpace, rhs: LabColorSpace) -> Bool {
        lhs.profile == rhs.profile
    }

}
