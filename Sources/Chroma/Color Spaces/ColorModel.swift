//
//  ColorModel.swift
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

/// Describes how colors are represented as a collection of values.
public struct ColorModel: Hashable {
    
    // MARK: - Types
    
    /// Information about a single value of a color model.
    public struct Component: Hashable {
        
        // MARK: - Properties
        
        /// The name of the component.
        var name: String
        
        /// The abbreviation of the component.
        var abbreviation: String
        
        /// The description of the component.
        var description: String
        
    }
    
    // MARK: - Properties
    
    /// The number of components in the color model.
    public var numberOfComponents: Int
    
    /// The name of the color model.
    public var name: String
    
    /// The model's components.
    public var components: [Component]
    
    // MARK: - Initialization
    
    /// Create a new color model.
    /// - Parameters:
    ///   - name: The name of the color model.
    ///   - components: The model's components.
    public init(name: String, components: [Component]) {
        self.name = name
        self.components = components
        self.numberOfComponents = components.count
    }
    
}
