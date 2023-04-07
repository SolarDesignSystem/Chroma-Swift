//
//  OkLChColorSpace.swift
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
public final class OkLchColorSpace: AlternativeColorSpace {
    
    // MARK: - Properties
    
    public let model: ColorModel = ColorModel(name: "OkLCh", components: [
        ColorModel.Component(name: "lightness", abbreviation: "L", description: ""),
        ColorModel.Component(name: "chroma", abbreviation: "C", description: ""),
        ColorModel.Component(name: "hue", abbreviation: "h", description: ""),
    ])
    
    public var profile: OkLabColorSpace.Profile {
        parent.profile
    }
    
    public let parent: OkLabColorSpace
    
    // MARK: - Initialization
    
    /// Creates a new Lch color space using the D65 illuminant with a 2° observer.
    public convenience init() {
        self.init(parent: OkLabColorSpace())
    }
    
    public convenience init(profile: OkLabColorSpace.Profile) {
        self.init(parent: OkLabColorSpace(profile: profile))
    }
    
    public init(parent: OkLabColorSpace) {
        self.parent = parent
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
        hasher.combine(parent)
    }
    
    public static func ==(lhs: OkLchColorSpace, rhs: OkLchColorSpace) -> Bool {
        lhs.parent == rhs.parent
    }

}
