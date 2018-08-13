/**
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

struct MorseData {
    // String representation of each morse signal
    enum Signal: String {
        case dot = "."
        case dash = "-"
        case unknown = "?"
    }
    
    // Letter to morse signal dictionary
    static var code: [String: [Signal]] = [
        "a": [.dot,.dash],
        "b": [.dash,.dot,.dot,.dot],
        "c": [.dash,.dot,.dash,.dot],
        "d": [.dash,.dot,.dot],
        "e": [.dot],
        "f": [.dot,.dot,.dash,.dot],
        "g": [.dash,.dash,.dot],
        "h": [.dot,.dot,.dot,.dot],
        "i": [.dot,.dot],
        "j": [.dot,.dash,.dash,.dash],
        "k": [.dash,.dot,.dash],
        "l": [.dot,.dash,.dot,.dot],
        "m": [.dash,.dash],
        "n": [.dash,.dot],
        "o": [.dash,.dash,.dash],
        "p": [.dot,.dash,.dash,.dot],
        "q": [.dash,.dash,.dot,.dash],
        "r": [.dot,.dash,.dot],
        "s": [.dot,.dot,.dot],
        "t": [.dash],
        "u": [.dot,.dot,.dash],
        "v": [.dot,.dot,.dot,.dash],
        "w": [.dot,.dash,.dash],
        "x": [.dash,.dot,.dot,.dash],
        "y": [.dash,.dot,.dash,.dash],
        "z": [.dash,.dash,.dot,.dot],
        "1": [.dot,.dash,.dash,.dash,.dash],
        "2": [.dot,.dot,.dash,.dash,.dash],
        "3": [.dot,.dot,.dot,.dash,.dash],
        "4": [.dot,.dot,.dot,.dot,.dash],
        "5": [.dot,.dot,.dot,.dot,.dot],
        "6": [.dash,.dot,.dot,.dot,.dot],
        "7": [.dash,.dash,.dot,.dot,.dot],
        "8": [.dash,.dash,.dash,.dot,.dot],
        "9": [.dash,.dash,.dash,.dash,.dot],
        "0": [.dash,.dash,.dash,.dash,.dash]
    ]
    
    /// Converts an array of signals into the associated letter if it exists
    static func letter(fromSignals signals: [Signal]) -> String? {
        return code.filter {
            $0.value == signals
            }.map {
                $0.key
            }.first
    }
}
