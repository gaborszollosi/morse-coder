/// Copyright (c) 2018. Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreLocation
import UIKit

class KeyboardViewController: UIInputViewController {
    
    var morseKeyboardView: MorseKeyboardView!
    var userLexicon: UILexicon?
    
    var currentWord: String? {
        var lastWord: String?
    
        if let stringBeforeCursor = textDocumentProxy.documentContextBeforeInput {
    
            stringBeforeCursor.enumerateSubstrings(in: stringBeforeCursor.startIndex..., options: .byWords) { word, _, _, _ in
                if let word = word {
                    lastWord = word
                }
            }
        }
        return lastWord
    }
    
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MorseKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        morseKeyboardView = objects.first as! MorseKeyboardView
        guard let inputView = inputView else { return }
        inputView.addSubview(morseKeyboardView)
        
        morseKeyboardView.delegate = self
        
        morseKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            morseKeyboardView.leftAnchor.constraint(equalTo: inputView.leftAnchor),
            morseKeyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
            morseKeyboardView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
            morseKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
            ])
        
        morseKeyboardView.setNextKeyboardVisible(needsInputModeSwitchKey)
        
        morseKeyboardView.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        requestSupplementaryLexicon { lexicon in
            self.userLexicon = lexicon
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        
        let colorScheme: MorseColorScheme
        
        if textDocumentProxy.keyboardAppearance == .dark {
            colorScheme = .dark
        } else {
            colorScheme = .light
        }
        
        morseKeyboardView.setColorScheme(colorScheme)
    }

}

// MARK: - MorseKeyboardViewDelegate
extension KeyboardViewController: MorseKeyboardViewDelegate {
    func insertCharacter(_ newCharacter: String) {
        if newCharacter == " " {
            if currentWord?.lowercased() == "sos",
                let currentLocation = currentLocation {
                
                let lat = currentLocation.coordinate.latitude
                let lng = currentLocation.coordinate.longitude
                
                textDocumentProxy.insertText(" (\(lat), \(lng))")
            } else {
                attemptToReplaceCurrentWord()
            }
        }
        
        textDocumentProxy.insertText(newCharacter)
    }
    
    func deleteCharacterBeforeCursor() {
        textDocumentProxy.deleteBackward()
    }
    
    func characterBeforeCursor() -> String? {
        
        guard let character = textDocumentProxy.documentContextBeforeInput?.last else {
            return nil
        }
        
        return String(character)
    }
}

// MARK: - Private methods
private extension KeyboardViewController {
    func attemptToReplaceCurrentWord() {
        
        guard let entries = userLexicon?.entries,
            let currentWord = currentWord?.lowercased() else { return }
        
        let replacementEntries = entries.filter {
            $0.userInput.lowercased() == currentWord
        }
        
        if let replacement = replacementEntries.first {
            for _ in 0..<currentWord.count {
                textDocumentProxy.deleteBackward()
            }
            
            textDocumentProxy.insertText(replacement.documentText)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension KeyboardViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
}
