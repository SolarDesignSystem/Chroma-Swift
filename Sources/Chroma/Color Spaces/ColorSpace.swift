//
//  ColorSpace.swift
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

/// The base protocol for color spaces.
public protocol ColorSpace {
    
    // MARK: - Properties
    
    /// The color model the color space is based on.
    var model: ColorModel { get }
    
    // MARK: - Initialization
    
    /// Create a new color space with the default profile.
    init()
    
}


/// A coordinate space for referencing and comparing colors.
public protocol ReferenceColorSpace: ColorSpace, Hashable {
    associatedtype AssociatedColorSpaceProfile: ReferenceColorSpaceProfile
    
    // MARK: - Properties
    
    /// The profile that defines the color space mathematically.
    var profile: AssociatedColorSpaceProfile { get }
    
    // MARK: - Initialization
    
    
    /// Creates a new color space.
    /// - Parameters:
    ///   - profile: The profile used to mathematically define the color space.
    init(profile: AssociatedColorSpaceProfile)
    
}

/// A alternative representation of a color space.
/// Alternative color spaces are defined relative to a non-XYZ color space and require being converted to / from their parent color space before being able to be converted into the root XYZ color space.
public protocol AlternativeColorSpace: ReferenceColorSpace {
    associatedtype ParentColorSpace: ColorSpace
    
    // MARK: - Properties
    
    /// The color space that this color space is an alternative representation of.
    var parent: ParentColorSpace { get }
    
}
