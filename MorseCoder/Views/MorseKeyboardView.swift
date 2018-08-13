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

/// Delegate method for the morse keyboard view that will allow it to perform
/// actions on whatever text entry you want to use it with. It does not assume
/// any type e.g. UITextField vs UITextView.
protocol MorseKeyboardViewDelegate: class {
    func insertCharacter(_ newCharacter: String)
    func deleteCharacterBeforeCursor()
    func characterBeforeCursor() -> String?
}

/// Contains all of the logic for handling button taps and translating that into
/// specific actions on the text entry associated with it
class MorseKeyboardView: UIView {
    @IBOutlet var previewLabel: UILabel!
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var spaceButtonToParentConstraint: NSLayoutConstraint!
    @IBOutlet var spaceButtonToNextKeyboardConstraint: NSLayoutConstraint!
    
    weak var delegate: MorseKeyboardViewDelegate?
    
    /// Cache of signal inputs
    var signalCache: [MorseData.Signal] = [] {
        didSet {
            var text = ""
            if signalCache.count > 0 {
                text = signalCache.reduce("") {
                    return $0 + $1.rawValue
                }
                text += " = \(cacheLetter)"
            }
            previewLabel.text = text
        }
    }
    
    /// The letter represented by the current signalCache
    var cacheLetter: String {
        return MorseData.letter(fromSignals: signalCache) ?? "?"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setColorScheme(.light)
        setNextKeyboardVisible(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setColorScheme(.light)
        setNextKeyboardVisible(false)
    }
    
    func setNextKeyboardVisible(_ visible: Bool) {
        spaceButtonToNextKeyboardConstraint.isActive = visible
        spaceButtonToParentConstraint.isActive = !visible
        nextKeyboardButton.isHidden = !visible
    }
    
    func setColorScheme(_ colorScheme: MorseColorScheme) {
        let colorScheme = MorseColors(colorScheme: colorScheme)
        previewLabel.backgroundColor = colorScheme.previewBackgroundColor
        previewLabel.textColor = colorScheme.previewTextColor
        backgroundColor = colorScheme.backgroundColor
        
        for view in subviews {
            if let button = view as? KeyboardButton {
                button.setTitleColor(colorScheme.buttonTextColor, for: [])
                button.tintColor = colorScheme.buttonTextColor
                
                if button == nextKeyboardButton || button == deleteButton {
                    button.defaultBackgroundColor = colorScheme.buttonHighlightColor
                    button.highlightBackgroundColor = colorScheme.buttonBackgroundColor
                } else {
                    button.defaultBackgroundColor = colorScheme.buttonBackgroundColor
                    button.highlightBackgroundColor = colorScheme.buttonHighlightColor
                }
            }
        }
    }
}

// MARK: - Actions
extension MorseKeyboardView {
    @IBAction func dotPressed(button: UIButton) {
        addSignal(.dot)
    }
    
    @IBAction func dashPressed() {
        addSignal(.dash)
    }
    
    @IBAction func deletePressed() {
        if signalCache.count > 0 {
            // Remove last signal
            signalCache.removeLast()
        } else {
            // Already didn't have a signal
            if let previousCharacter = delegate?.characterBeforeCursor() {
                if let previousSignals = MorseData.code["\(previousCharacter)"] {
                    signalCache = previousSignals
                }
            }
        }
        
        if signalCache.count == 0 {
            // Delete because no more signal
            delegate?.deleteCharacterBeforeCursor()
        } else {
            // Building on existing letter by deleting current
            delegate?.deleteCharacterBeforeCursor()
            delegate?.insertCharacter(cacheLetter)
        }
    }
    
    @IBAction func spacePressed() {
        if signalCache.count > 0 {
            // Clear our the signal cache
            signalCache = []
        } else {
            delegate?.insertCharacter(" ")
        }
    }
}

// MARK: - Private Methods
private extension MorseKeyboardView {
    func addSignal(_ signal: MorseData.Signal) {
        if signalCache.count == 0 {
            // Have an empty cache
            signalCache.append(signal)
            delegate?.insertCharacter(cacheLetter)
        } else {
            // Building on existing letter
            signalCache.append(signal)
            delegate?.deleteCharacterBeforeCursor()
            delegate?.insertCharacter(cacheLetter)
        }
    }
}
