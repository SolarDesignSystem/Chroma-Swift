//
//  Utilities.swift
//  Chroma
//
//  Created by Solar Design System on 4/5/23.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2023 Solar Design System
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest
import Matrix

func XCTAssertEqual<T: FloatingPoint>(_ a: Matrix<T>, _ b: Matrix<T>, accuracy: T, _ message: String) {
    XCTAssertEqual(a.rowCount, b.rowCount, message)
    XCTAssertEqual(a.columnCount, b.columnCount, message)
    guard a.rowCount == b.rowCount && a.columnCount == b.columnCount else {
        return
    }
    
    for row in 0..<a.rowCount {
        for col in 0..<a.columnCount {
            XCTAssertEqual(a[row, col], b[row, col], accuracy: accuracy, message)
        }
    }
}
