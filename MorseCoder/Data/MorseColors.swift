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

import UIKit

enum MorseColorScheme {
    case dark
    case light
}

struct MorseColors {
    let buttonTextColor: UIColor
    let buttonBackgroundColor: UIColor
    let buttonHighlightColor: UIColor
    let backgroundColor: UIColor
    let previewTextColor: UIColor
    let previewBackgroundColor: UIColor
    
    init(colorScheme: MorseColorScheme) {
        switch colorScheme {
        case .light:
            buttonTextColor = .black
            buttonBackgroundColor = .white
            buttonHighlightColor = UIColor(red: 174/255, green: 179/255, blue: 190/255, alpha: 1.0)
            backgroundColor = UIColor(red: 210/255, green: 213/255, blue: 219/255, alpha: 1.0)
            previewTextColor = .white
            previewBackgroundColor = UIColor(red: 186/255, green: 191/255, blue: 200/255, alpha: 1.0)
        case .dark:
            buttonTextColor = .white
            buttonBackgroundColor = UIColor(white: 138/255, alpha: 1.0)
            buttonHighlightColor = UIColor(white: 104/255, alpha: 1.0)
            backgroundColor = UIColor(white:89/255, alpha: 1.0)
            previewTextColor = .white
            previewBackgroundColor = UIColor(white: 80/255, alpha: 1.0)
        }
    }
}
