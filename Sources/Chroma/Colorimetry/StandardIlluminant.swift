//
//  StandardIlluminant.swift
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

import Foundation

///  A theoretical source of visible light where its profile (spectral power distribution) is published.
///
/// *References*
/// - [Wikipedia](https://en.wikipedia.org/wiki/Standard_illuminant)
public struct StandardIlluminant: Hashable {
    
    // MARK: - Properties
    
    /// The name of the illuminant.
    public var name: String
    
    /// The group of illuminants this illuminant belongs to.
    public var group: String
    
    /// Additional details describing the illuminant.
    public var details: String
    
    /// The white point of the illuminant.
    public var whitePoint: XyChromaticityCoordinate
    
    /// The field of view used when calculating the value of the standard illuminant (in degrees).
    public var fieldOfView: Double
    
    // MARK: - Initialization
    
    
    /// Create a new illuminant.
    /// - Parameters:
    ///   - name: The name of the illuminant.
    ///   - group: The group of illuminants this illuminant belongs to.
    ///   - details: Additional details describing the illuminant.
    ///   - coordinate: The white point of the illuminant.
    ///   - fieldOfView: The field of view used when calculating the value of the standard illuminant (in degrees).
    public init(name: String, group: String, details: String, coordinate: XyChromaticityCoordinate, fieldOfView: Double = 2.0) {
        self.name = name
        self.group = group
        self.details = details
        self.whitePoint = coordinate
        self.fieldOfView = fieldOfView
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(fieldOfView)
        hasher.combine(whitePoint)
    }
    
    public static func ==(lhs: StandardIlluminant, rhs: StandardIlluminant) -> Bool {
        lhs.fieldOfView == rhs.fieldOfView && lhs.whitePoint == rhs.whitePoint
    }
    
}

// MARK: - Standards

extension StandardIlluminant {
    
    /// The standard illuminants with their white points calculated using a two degree field of view.
    public struct TwoDegree {
        
        // MARK: - Standard Incandescent Illuminants
        
        /// An incandescent or tungsten bulb.
        public static let a: StandardIlluminant = StandardIlluminant(name: "A", group: "Standard Incandescent Illuminants", details: "An incandescent or tungsten bulb.", coordinate: XyChromaticityCoordinate(x: 0.44757, y: 0.40745), fieldOfView: 2.0)
        
        // MARK: - Energy Based Illuminants
        
        /// Equal energy light.
        public static let e: StandardIlluminant = StandardIlluminant(name: "E", group: "Energy Based Illuminants", details: "Equal energy light.", coordinate: XyChromaticityCoordinate(x: 1.0 / 3.0, y: 1.0 / 3.0), fieldOfView: 2.0)
        
        // MARK: - Daylight Illuminants
        
        /// Light at the horizon.
        public static let d50: StandardIlluminant = StandardIlluminant(name: "D50", group: "Daylight Illuminants", details: "Light at the horizon.", coordinate: XyChromaticityCoordinate(x: 0.34567, y: 0.35850), fieldOfView: 2.0)
        
        /// Mid-morning or mid-afternoon daylight.
        public static let d55: StandardIlluminant = StandardIlluminant(name: "D55", group: "Daylight Illuminants", details: "Mid-morning or mid-afternoon daylight.", coordinate: XyChromaticityCoordinate(x: 0.33242, y: 0.34743), fieldOfView: 2.0)
        
        /// Noon daylight.
        public static let d65: StandardIlluminant = StandardIlluminant(name: "D65", group: "Daylight Illuminants", details: "Noon daylight.", coordinate: XyChromaticityCoordinate(x: 0.31271, y: 0.32902), fieldOfView: 2.0)
        
        /// North sky daylight.
        public static let d75: StandardIlluminant = StandardIlluminant(name: "D65", group: "Daylight Illuminants", details: "North sky daylight.", coordinate: XyChromaticityCoordinate(x: 0.29902, y: 0.31485), fieldOfView: 2.0)
        
        // MARK: - Standard Flourescent Illuminants
        
        /// Daylight fluorescent bulb.
        public static let f1: StandardIlluminant = StandardIlluminant(name: "F1", group: "Standard Fluorescent Illuminants", details: "Daylight fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.31310, y: 0.33727), fieldOfView: 2.0)
        
        /// Cool white fluorescent bulb.
        public static let f2: StandardIlluminant = StandardIlluminant(name: "F2", group: "Standard Fluorescent Illuminants", details: "Cool white fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.37208, y: 0.37529), fieldOfView: 2.0)
        
        /// White fluorescent bulb.
        public static let f3: StandardIlluminant = StandardIlluminant(name: "F3", group: "Standard Fluorescent Illuminants", details: "White fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.40910, y: 0.39430), fieldOfView: 2.0)
        
        /// Warm white fluorescent bulb.
        public static let f4: StandardIlluminant = StandardIlluminant(name: "F4", group: "Standard Fluorescent Illuminants", details: "Warm white fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.44018, y: 0.40329), fieldOfView: 2.0)
        
        /// Daylight fluorescent bulb.
        public static let f5: StandardIlluminant = StandardIlluminant(name: "F5", group: "Standard Fluorescent Illuminants", details: "Daylight fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.31379, y: 0.34531), fieldOfView: 2.0)
        
        /// Lite white fluorescent bulb.
        public static let f6: StandardIlluminant = StandardIlluminant(name: "F6", group: "Standard Fluorescent Illuminants", details: "Lite white fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.37790, y: 0.38835), fieldOfView: 2.0)
        
        // MARK: - Broadband Flourescent Illuminants
        
        /// Daylight / D65 simulator fluorescent bulb.
        public static let f7: StandardIlluminant = StandardIlluminant(name: "F7", group: "Broadband Fluorescent Illuminants", details: "Daylight / D65 simulator fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.31292, y: 0.32933), fieldOfView: 2.0)
        
        /// Mid-morning / D55 simulator fluorescent bulb.
        public static let f8: StandardIlluminant = StandardIlluminant(name: "F8", group: "Broadband Fluorescent Illuminants", details: "Mid-morning / D55 simulator fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.34588, y: 0.35875), fieldOfView: 2.0)
        
        /// Cool white deluxe fluorescent bulb.
        public static let f9: StandardIlluminant = StandardIlluminant(name: "F9", group: "Broadband Fluorescent Illuminants", details: "Cool white deluxe fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.37417, y: 0.37281), fieldOfView: 2.0)
        
        // MARK: - Narrow Tri-band Flourescent Illuminants
        
        /// A Philips TL85 or Ultralume 50 bulb.
        public static let f10: StandardIlluminant = StandardIlluminant(name: "F10", group: "Narrow Tri-band Fluorescent Illuminants", details: "A Philips TL85 or Ultralume 50 bulb.", coordinate: XyChromaticityCoordinate(x: 0.34609, y: 0.35986), fieldOfView: 2.0)
        
        /// A Philips TL84 or Ultralume 40 bulb.
        public static let f11: StandardIlluminant = StandardIlluminant(name: "F11", group: "Narrow Tri-band Fluorescent Illuminants", details: "A Philips TL84 or Ultralume 40 bulb.", coordinate: XyChromaticityCoordinate(x: 0.38052, y: 0.37713), fieldOfView: 2.0)
        
        /// A Philips TL83 or Ultralume 30 bulb.
        public static let f12: StandardIlluminant = StandardIlluminant(name: "F12", group: "Narrow Tri-band Fluorescent Illuminants", details: "A Philips TL83 or Ultralume 30 bulb.", coordinate: XyChromaticityCoordinate(x: 0.43695, y: 0.40441), fieldOfView: 2.0)
        
        // MARK: - Obsolete Illuminants
        
        /// Direct sunlight at noon.
        public static let b: StandardIlluminant = StandardIlluminant(name: "B", group: "Obsolete Illuminants", details: "Direct sunlight at noon.", coordinate: XyChromaticityCoordinate(x: 0.34842, y: 0.35161), fieldOfView: 2.0)
        
        /// Average northern sky daylight.
        public static let c: StandardIlluminant = StandardIlluminant(name: "C", group: "Obsolete Illuminants", details: "Average northern sky daylight.", coordinate: XyChromaticityCoordinate(x: 0.31006, y: 0.31616), fieldOfView: 2.0)
        
        // MARK: - All Illuminants
        
        /// An array of all the pre-configured illuminants.
        public static let all: [StandardIlluminant] = [a, b, c, e, d50, d55, d65, d75, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12]
        
    }
    
    /// The standard illuminants with their white points calculated using a ten degree field of view.
    public struct TenDegree {
        
        // MARK: - Standard Incandescent Illuminants
        
        /// An incandescent or tungsten bulb.
        public static let a: StandardIlluminant = StandardIlluminant(name: "A", group: "Standard Incandescent Illuminants", details: "An incandescent or tungsten bulb.", coordinate: XyChromaticityCoordinate(x: 0.45117, y: 0.40594), fieldOfView: 10.0)
        
        // MARK: - Energy Based Illuminants
        
        /// Equal energy light.
        public static let e: StandardIlluminant = StandardIlluminant(name: "E", group: "Energy Based Illuminants", details: "Equal energy light.", coordinate: XyChromaticityCoordinate(x: 1.0 / 3.0, y: 1.0 / 3.0), fieldOfView: 10.0)
        
        // MARK: - Daylight Illuminants
        
        /// Light at the horizon.
        public static let d50: StandardIlluminant = StandardIlluminant(name: "D50", group: "Daylight Illuminants", details: "Light at the horizon.", coordinate: XyChromaticityCoordinate(x: 0.34773, y: 0.35952), fieldOfView: 10.0)
        
        /// Mid-morning or mid-afternoon daylight.
        public static let d55: StandardIlluminant = StandardIlluminant(name: "D55", group: "Daylight Illuminants", details: "Mid-morning or mid-afternoon daylight.", coordinate: XyChromaticityCoordinate(x: 0.33411, y: 0.34877), fieldOfView: 10.0)
        
        /// Noon daylight.
        public static let d65: StandardIlluminant = StandardIlluminant(name: "D65", group: "Daylight Illuminants", details: "Noon daylight.", coordinate: XyChromaticityCoordinate(x: 0.31382, y: 0.33100), fieldOfView: 10.0)
        
        /// North sky daylight.
        public static let d75: StandardIlluminant = StandardIlluminant(name: "D65", group: "Daylight Illuminants", details: "North sky daylight.", coordinate: XyChromaticityCoordinate(x: 0.29968, y: 0.31740), fieldOfView: 10.0)
        
        // MARK: - Standard Flourescent Illuminants
        
        /// Daylight fluorescent bulb.
        public static let f1: StandardIlluminant = StandardIlluminant(name: "F1", group: "Standard Fluorescent Illuminants", details: "Daylight fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.31811, y: 0.33559), fieldOfView: 10.0)
        
        /// Cool white fluorescent bulb.
        public static let f2: StandardIlluminant = StandardIlluminant(name: "F2", group: "Standard Fluorescent Illuminants", details: "Cool white fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.37925, y: 0.36733), fieldOfView: 10.0)
        
        /// White fluorescent bulb.
        public static let f3: StandardIlluminant = StandardIlluminant(name: "F3", group: "Standard Fluorescent Illuminants", details: "White fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.41761, y: 0.38324), fieldOfView: 10.0)
        
        /// Warm white fluorescent bulb.
        public static let f4: StandardIlluminant = StandardIlluminant(name: "F4", group: "Standard Fluorescent Illuminants", details: "Warm white fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.44920, y: 0.39074), fieldOfView: 10.0)
        
        /// Daylight fluorescent bulb.
        public static let f5: StandardIlluminant = StandardIlluminant(name: "F5", group: "Standard Fluorescent Illuminants", details: "Daylight fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.31975, y: 0.34246), fieldOfView: 10.0)
        
        /// Lite white fluorescent bulb.
        public static let f6: StandardIlluminant = StandardIlluminant(name: "F6", group: "Standard Fluorescent Illuminants", details: "Lite white fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.38660, y: 0.37847), fieldOfView: 10.0)
        
        // MARK: - Broadband Flourescent Illuminants
        
        /// Daylight / D65 simulator fluorescent bulb.
        public static let f7: StandardIlluminant = StandardIlluminant(name: "F7", group: "Broadband Fluorescent Illuminants", details: "Daylight / D65 simulator fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.31569, y: 0.32960), fieldOfView: 10.0)
        
        /// Mid-morning / D55 simulator fluorescent bulb.
        public static let f8: StandardIlluminant = StandardIlluminant(name: "F8", group: "Broadband Fluorescent Illuminants", details: "Mid-morning / D55 simulator fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.34902, y: 0.35939), fieldOfView: 10.0)
        
        /// Cool white deluxe fluorescent bulb.
        public static let f9: StandardIlluminant = StandardIlluminant(name: "F9", group: "Broadband Fluorescent Illuminants", details: "Cool white deluxe fluorescent bulb.", coordinate: XyChromaticityCoordinate(x: 0.37829, y: 0.37045), fieldOfView: 10.0)
        
        // MARK: - Narrow Tri-band Flourescent Illuminants
        
        /// A Philips TL85 or Ultralume 50 bulb.
        public static let f10: StandardIlluminant = StandardIlluminant(name: "F10", group: "Narrow Tri-band Fluorescent Illuminants", details: "A Philips TL85 or Ultralume 50 bulb.", coordinate: XyChromaticityCoordinate(x: 0.35090, y: 0.35444), fieldOfView: 10.0)
        
        /// A Philips TL84 or Ultralume 40 bulb.
        public static let f11: StandardIlluminant = StandardIlluminant(name: "F11", group: "Narrow Tri-band Fluorescent Illuminants", details: "A Philips TL84 or Ultralume 40 bulb.", coordinate: XyChromaticityCoordinate(x: 0.38541, y: 0.37123), fieldOfView: 10.0)
        
        /// A Philips TL83 or Ultralume 30 bulb.
        public static let f12: StandardIlluminant = StandardIlluminant(name: "F12", group: "Narrow Tri-band Fluorescent Illuminants", details: "A Philips TL83 or Ultralume 30 bulb.", coordinate: XyChromaticityCoordinate(x: 0.44256, y: 0.39717), fieldOfView: 10.0)
        
        // MARK: - Obsolete Illuminants
        
        /// Direct sunlight at noon.
        public static let b: StandardIlluminant = StandardIlluminant(name: "B", group: "Obsolete Illuminants", details: "Direct sunlight at noon.", coordinate: XyChromaticityCoordinate(x: 0.34980, y: 0.35270), fieldOfView: 10.0)
        
        /// Average northern sky daylight.
        public static let c: StandardIlluminant = StandardIlluminant(name: "C", group: "Obsolete Illuminants", details: "Average northern sky daylight.", coordinate: XyChromaticityCoordinate(x: 0.31039, y: 0.31905), fieldOfView: 10.0)
        
        // MARK: - All Illuminants
        
        /// An array of all the pre-configured illuminants.
        public static let all: [StandardIlluminant] = [a, b, c, e, d50, d55, d65, d75, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12]
    }
    
    /// An array of all the pre-configured illuminants.
    public static let all: [StandardIlluminant] = TwoDegree.all + TenDegree.all
    
}
