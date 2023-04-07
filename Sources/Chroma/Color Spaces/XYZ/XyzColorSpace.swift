//
//  XyzColorSpace.swift
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

/// The CIE 1931 XYZ color space: a three component, device independent color space that defines colors using components that model human vision.
public final class XyzColorSpace: ReferenceColorSpace {
    
    // MARK: - Profile
    
    /// The profile that defines the XYZ color space.
    public struct Profile: ReferenceColorSpaceProfile, Hashable {
        
        public var referenceWhite: StandardIlluminant
        
        public init(referenceWhite: StandardIlluminant) {
            self.referenceWhite = referenceWhite
        }
        
    }
    
    // MARK: - Properties
    
    public let model: ColorModel = ColorModel(name: "XYZ", components: [
        ColorModel.Component(name: "X", abbreviation: "X", description: ""),
        ColorModel.Component(name: "Luminance", abbreviation: "Y", description: ""),
        ColorModel.Component(name: "Z", abbreviation: "Z", description: ""),
    ])
    
    public let profile: Profile
    
    // MARK: - Initialization
    
    
    /// Create a new XYZ color space using the D65 illuminant with a 2° observer.
    public convenience init() {
        self.init(profile: Profile(referenceWhite: StandardIlluminant.TwoDegree.d65))
    }
    
    /// Creates a new XYZ color space.
    /// - Parameter profile: The profile used to mathematically define the color space.
    public init(profile: Profile) {
        self.profile = profile
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
        hasher.combine(profile)
    }
    
    public static func ==(lhs: XyzColorSpace, rhs: XyzColorSpace) -> Bool {
        lhs.profile == rhs.profile
    }
    
}
