//
//  Color.swift
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

import Matrix

/// The base protocol for colors without the associated color space.
public protocol Color {
    
    // MARK: - Properties
    
    /// The components that define the color in its color space.
    var components: [Double] { get }
    
    
    /// The opacity of the color.
    /// Expected range: [0, 1]
    var opacity: Double { get set }
    
    // MARK: - Color Conversion
    
    /// Converts the color to the "base" XYZ color space.
    /// - Returns: The equivalent color in the XYZ color space, or `nil` if the color is unable to be converted..
    func toXyzColor() -> XyzColor?
    
    /// Creates a new color from a color in the XYZ color space using the default color space for the chosen type of color. The initializer will return `nil` if the XYZ color is unable to be converted.
    /// - Parameter xyzColor: xyzColor: The equivalent XYZ color to convert to this color type.
    init?(_ xyzColor: XyzColor)
    
}

/// An object that stores color data.
public protocol ReferenceColor: Color, Hashable {
    associatedtype AssociatedColorSpace: ReferenceColorSpace
    
    // MARK: - Properties
    
    /// The color space associated with the color.
    var colorSpace: AssociatedColorSpace { get }
    
    // MARK: - Color Conversion
    
    /// Creates a new color from a color in the XYZ color space.
    /// - Parameters:
    ///   - xyzColor: The equivalent XYZ color to convert to this color type.
    ///   - colorSpace: The color space to use when converting the `xyzColor`.
    init?(_ xyzColor: XyzColor, colorSpace: AssociatedColorSpace)
    
}

public protocol AlternativeColor: ReferenceColor where AssociatedColorSpace: AlternativeColorSpace, AssociatedColorSpace.ParentColorSpace == ParentColor.AssociatedColorSpace {
    associatedtype ParentColor: ReferenceColor
    
    // MARK: - Properties
    
    /// Converts the color to its parent color type.
    /// - Returns: The equivalent color in the parent color space, or `nil` if the color is unable to be converted..
    func toParent() -> ParentColor?
    
    // MARK: - Initialization
    
    /// Creates a new color from a color in the parent color space.
    /// - Parameter parentColor: The equivalent color to convert to this color type.
    init?(_ parentColor: ParentColor)
    
}

extension ReferenceColor {
    
    /// Convert the color to an equivalent color in the specified color space.
    /// - Parameter space: The target color space.
    /// - Returns: The equivalent of the color in the target color space if it is able to be converted. If the color is unable to be converted, this function will return `nil`.
    public func using<T>(_ space: T.AssociatedColorSpace) -> T? where T: ReferenceColor {
        guard var xyzColor = toXyzColor() else {
            return nil
        }
        
        let targetReferenceWhite: StandardIlluminant = space.profile.referenceWhite

        if xyzColor.colorSpace.profile.referenceWhite != targetReferenceWhite {
            xyzColor = xyzColor.adapt(to: targetReferenceWhite)
        }
        
        return T(xyzColor, colorSpace: space)
    }
    
    
    /// Convert the color to a matrix.
    internal var matrixForm: Matrix<Double> {
        Matrix(elements: components, rowCount: components.count, columnCount: 1)
    }
    
}
