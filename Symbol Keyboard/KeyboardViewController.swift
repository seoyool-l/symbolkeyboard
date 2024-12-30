//
//  KeyboardViewController.swift
//  Symbol Keyboard
//
//  Created by Seoyool Lee on 10/12/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    @IBOutlet var nextKeyboardButton: UIButton!
    var backspaceTimer: Timer?
    var backspaceSecondaryTimer: Timer?
    var backspaceInitialTimer: Timer?
    var backspaceSecondaryInitialTimer: Timer?
    var shiftTimer: Timer?
    var numberTimer: Timer?
    var moveBackToEnglish = 0
    var numberSwitched = false
    var activeOperator = 0
    var enterSecondNumber = false
    var firstNumber = 0.0
    var secondNumber = 0.0
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
        let heightConstraint = NSLayoutConstraint(
            item: self.view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 216
        )
        
        self.view.addConstraint(heightConstraint)
    }
    var keyboardType = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "EngKeyboardView", bundle: nil)
        
        if let keyboardView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view = keyboardView
            keyboardType = 1
            appearance()
        }
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    let alphabetLowercase = ["q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"]
    let alphabetUppercase = ["Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M"]
    let keyboard3_numbers = ["1","2","3","4","5","6","7","8","9","0"," "," ","x","y","z","a","b","c"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","Calc"," "," "," "]
    let keyboard4_numbers = ["1","2","3","4","5","6","7","8","9","0"," ","x","y","z"," "," "," "," "," ","a","b"," "," "," "," "," "," "," ","c"," "," "," "," "," ","Calc"," "," "," "]
    @IBAction func buttonPressed(button: UIButton)
    {
        haptic()
        if traitCollection.userInterfaceStyle == .dark {
            button.backgroundColor = UIColor.systemGray
        }
        else {
            button.backgroundColor = UIColor.systemGray4
        }
        let string = button.titleLabel?.text
        (textDocumentProxy as UIKeyInput).insertText("\(string!)")
        if keyboardType == 1 {
            if capsLock == false {
                if let shift = self.view.viewWithTag(27) as? UIButton {
                    if traitCollection.userInterfaceStyle == .dark {
                        if shift.backgroundColor == UIColor.white {
                            shift.backgroundColor = UIColor.systemGray2
                            shift.configuration?.baseForegroundColor = UIColor.white
                            for i in 1...26 {
                                if let changeCaseButton = self.view.viewWithTag(i) as? UIButton {
                                    changeCaseButton.setTitle(alphabetLowercase[i-1], for: .normal)
                                }
                            }
                        }
                    }
                    else {
                        if shift.backgroundColor == UIColor.systemGray2 {
                            shift.backgroundColor = UIColor.white
                            shift.configuration?.baseForegroundColor = UIColor.black
                            for i in 1...26 {
                                if let changeCaseButton = self.view.viewWithTag(i) as? UIButton {
                                    changeCaseButton.setTitle(alphabetLowercase[i-1], for: .normal)
                                }
                            }
                        }
                    }
                }
            }
        }
        if keyboardType == 2 {
            if button.tag == 13 || button.tag == 14 || button.tag == 18 || button.tag == 20 || button.tag == 21 || button.tag == 22 || button.tag == 23 || button.tag == 25 {
                moveBackToEnglish = 1
            }
            else if button.tag == 24 {
                let newNib = UINib(nibName: "EngKeyboardView", bundle: nil)
                if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
                    view = newKeyboardView
                    keyboardType = 1
                    moveBackToEnglish = 0
                    appearance()
                    capsLock = false
                }
            }
            else {
                moveBackToEnglish = 0
            }
        }
        else {
            moveBackToEnglish = 0
        }
    }
    @IBAction func buttonReleased(button: UIButton) {
        if traitCollection.userInterfaceStyle == .dark {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                button.backgroundColor = UIColor.systemGray2
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                button.backgroundColor = UIColor.white
            }
        }
    }
    @objc func haptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    @IBAction func spaceButtonPressed(button: UIButton)
    {
        haptic()
        if traitCollection.userInterfaceStyle == .dark {
            button.backgroundColor = UIColor.systemGray
        }
        else {
            button.backgroundColor = UIColor.systemGray4
        }
        if keyboardType == 2 {
            if moveBackToEnglish == 1 {
                (textDocumentProxy as UIKeyInput).insertText(" ")
                let newNib = UINib(nibName: "EngKeyboardView", bundle: nil)
                if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
                    view = newKeyboardView
                    keyboardType = 1
                    moveBackToEnglish = 0
                    appearance()
                    capsLock = false
                }
            }
        }
        if keyboardType == 3 || keyboardType == 4 {
            numberTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(numberSwitch), userInfo: nil, repeats: false)
        }
    }
    @objc func numberSwitch() {
        if keyboardType == 3 {
            for i in 1...42 {
                if let changeButton = self.view.viewWithTag(i) as? UIButton {
                    changeButton.setTitle(keyboard3_numbers[i-1], for: .normal)
                }
            }
            if let button = self.view.viewWithTag(38) as? UIButton{
                button.configuration?.subtitle = ""
            }
        }
        if keyboardType == 4 {
            for i in 1...37 {
                if let changeButton = self.view.viewWithTag(i) as? UIButton {
                    changeButton.setTitle(keyboard4_numbers[i-1], for: .normal)
                }
            }
        }
        numberSwitched = true
    }
    @IBAction func spaceButtonReleased(button: UIButton) {
        numberTimer?.invalidate()
        numberTimer = nil
        if traitCollection.userInterfaceStyle == .dark {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                button.backgroundColor = UIColor.systemGray2
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                button.backgroundColor = UIColor.white
            }
        }
        if numberSwitched == true {
            if keyboardType == 3 {
                let newNib = UINib(nibName: "MathKeyboardView", bundle: nil)
                if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
                    view = newKeyboardView
                    appearance()
                }
                numberSwitched = false
            }
            if keyboardType == 4 {
                let newNib = UINib(nibName: "SupscrSubscrKeyboardView", bundle: nil)
                if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
                    view = newKeyboardView
                    appearance()
                }
                numberSwitched = false
            }
        }
        else {
            if moveBackToEnglish == 0 {
                (textDocumentProxy as UIKeyInput).insertText(" ")
            }
        }
    }
    var capsLock = false
    var lastPressTime: Date?
    @IBAction func shiftButtonPressed(button: UIButton)
    {
        haptic()
        if let button = self.view.viewWithTag(27) as? UIButton{
            let currentTime = Date()
            if traitCollection.userInterfaceStyle == .dark {
                if button.backgroundColor == UIColor.white { // shift activated to deactivated
                    if capsLock == true {
                        button.backgroundColor = UIColor.systemGray2
                        button.configuration?.baseForegroundColor = UIColor.white
                        for i in 1...26 {
                            if let changeCaseButton = self.view.viewWithTag(i) as? UIButton {
                                changeCaseButton.setTitle(alphabetLowercase[i-1], for: .normal)
                            }
                        }
                        capsLock = false
                        button.setTitle("⇧", for: .normal)
                    }
                    else {
                        if let lastPress = lastPressTime, currentTime.timeIntervalSince(lastPress) < 0.3 {
                            capsLock = true
                            if let button = self.view.viewWithTag(27) as? UIButton {
                                button.setTitle("⇪", for: .normal)
                            }
                        }
                        else {
                            button.backgroundColor = UIColor.systemGray2
                            button.configuration?.baseForegroundColor = UIColor.white
                            for i in 1...26 {
                                if let changeCaseButton = self.view.viewWithTag(i) as? UIButton {
                                    changeCaseButton.setTitle(alphabetLowercase[i-1], for: .normal)
                                }
                            }
                        }
                    }
                }
                else { // shift deactivated to activated
                    button.backgroundColor = UIColor.white
                    button.configuration?.baseForegroundColor = UIColor.black
                    for i in 1...26 {
                        if let changeCaseButton = self.view.viewWithTag(i) as? UIButton {
                            changeCaseButton.setTitle(alphabetUppercase[i-1], for: .normal)
                        }
                    }
                }
            }
            else {
                if button.backgroundColor == UIColor.systemGray2 { // shift activated to deactivated
                    if capsLock == true {
                        button.backgroundColor = UIColor.white
                        button.configuration?.baseForegroundColor = UIColor.black
                        for i in 1...26 {
                            if let changeCaseButton = self.view.viewWithTag(i) as? UIButton {
                                changeCaseButton.setTitle(alphabetLowercase[i-1], for: .normal)
                            }
                        }
                        capsLock = false
                        button.setTitle("⇧", for: .normal)
                    }
                    else {
                        if let lastPress = lastPressTime, currentTime.timeIntervalSince(lastPress) < 0.3 {
                            capsLock = true
                            if let button = self.view.viewWithTag(27) as? UIButton {
                                button.setTitle("⇪", for: .normal)
                            }
                        }
                        else {
                            button.backgroundColor = UIColor.white
                            button.configuration?.baseForegroundColor = UIColor.black
                            for i in 1...26 {
                                if let changeCaseButton = self.view.viewWithTag(i) as? UIButton {
                                    changeCaseButton.setTitle(alphabetLowercase[i-1], for: .normal)
                                }
                            }
                        }
                    }
                }
                else { // shift deactivated to activated
                    button.backgroundColor = UIColor.systemGray2
                    button.configuration?.baseForegroundColor = UIColor.white
                    for i in 1...26 {
                        if let changeCaseButton = self.view.viewWithTag(i) as? UIButton {
                            changeCaseButton.setTitle(alphabetUppercase[i-1], for: .normal)
                        }
                    }
                }
            }
            lastPressTime = currentTime
        }
    }
    @IBAction func backButtonPressed(button: UIButton)
    {
        haptic()
        if traitCollection.userInterfaceStyle == .dark {
            button.backgroundColor = UIColor.systemGray
        }
        else {
            button.backgroundColor = UIColor.systemGray4
        }
        (textDocumentProxy as UIKeyInput).deleteBackward()
        moveBackToEnglish = 0
        backspaceInitialTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(backspaceHoldStart), userInfo: nil, repeats: false)
        backspaceSecondaryInitialTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(backspaceHoldSecondaryStart), userInfo: nil, repeats: false)
    }
    @IBAction func backButtonReleased(_ button: UIButton) {
        if traitCollection.userInterfaceStyle == .dark {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                button.backgroundColor = UIColor.systemGray2
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                button.backgroundColor = UIColor.white
            }
        }
        backspaceInitialTimer?.invalidate()
        backspaceTimer?.invalidate()
        backspaceSecondaryInitialTimer?.invalidate()
        backspaceSecondaryTimer?.invalidate()
        backspaceInitialTimer = nil
        backspaceTimer = nil
        backspaceSecondaryInitialTimer = nil
        backspaceSecondaryTimer = nil
    }
    @objc func backspaceHoldStart() {
        backspaceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(backspaceHold), userInfo: nil, repeats: true)
    }
    @objc func backspaceHoldSecondaryStart() {
        backspaceTimer?.invalidate()
        backspaceTimer = nil
        backspaceSecondaryTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(backspaceHoldSecondary), userInfo: nil, repeats: true)
    }
    @objc func backspaceHold() {
        haptic()
        (textDocumentProxy as UIKeyInput).deleteBackward()
    }
    @objc func backspaceHoldSecondary() {
        haptic()
        (textDocumentProxy as UIKeyInput).deleteBackward()
        (textDocumentProxy as UIKeyInput).deleteBackward()
        (textDocumentProxy as UIKeyInput).deleteBackward()
        (textDocumentProxy as UIKeyInput).deleteBackward()
        (textDocumentProxy as UIKeyInput).deleteBackward()
    }
    @IBAction func returnButtonPressed(button: UIButton)
    {
        haptic()
        if traitCollection.userInterfaceStyle == .dark {
            button.backgroundColor = UIColor.systemGray
        }
        else {
            button.backgroundColor = UIColor.systemGray4
        }
        (textDocumentProxy as UIKeyInput).insertText("\n")
        moveBackToEnglish = 0
    }
    @IBAction func returnButtonReleased(button: UIButton){
        if traitCollection.userInterfaceStyle == .dark {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                button.backgroundColor = UIColor.systemGray2
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                button.backgroundColor = UIColor.white
            }
        }
    }
    @IBAction func calc_buttonPressed(button: UIButton) {
        haptic()
        if traitCollection.userInterfaceStyle == .dark {
            button.backgroundColor = UIColor.systemGray
        }
        else {
            button.backgroundColor = UIColor.systemGray4
        }
        if button.tag == 13 {
            if let label = self.view.viewWithTag(1) as? UILabel {
                if enterSecondNumber == true {
                    if let existingText = label.text {
                        if existingText.count >= 3 {
                            let modifiedExistingText = String(existingText.dropFirst(3))
                            firstNumber = Double(modifiedExistingText) ?? 0.0
                            label.text = "   -0"
                            enterSecondNumber = false
                        }
                    }
                }
                else {
                    if let existingText = label.text {
                        if existingText.count >= 3 {
                            var modifiedExistingText = String(existingText.dropFirst(3))
                            if modifiedExistingText[modifiedExistingText.startIndex] == "-" {
                                modifiedExistingText = String(modifiedExistingText.dropFirst(1))
                                label.text = "   " + modifiedExistingText
                            }
                            else {
                                label.text = "   -" + modifiedExistingText
                            }
                        }
                    }
                }
            }
        }
        else {
            let string = button.titleLabel?.text
            if let label = self.view.viewWithTag(1) as? UILabel {
                if enterSecondNumber == true {
                    if let existingText = label.text {
                        if existingText.count >= 3 {
                            let modifiedExistingText = String(existingText.dropFirst(3))
                            firstNumber = Double(modifiedExistingText) ?? 0.0
                            if button.tag == 12 {
                                label.text = "   0."
                            }
                            else {
                                label.text = "   " + (string ?? "")
                            }
                            enterSecondNumber = false
                        }
                    }
                }
                else {
                    if let existingText = label.text {
                        if button.tag == 12 {
                            if !existingText.contains(".") {
                                label.text = existingText + "."
                            }
                        }
                        else {
                            if existingText == "   0" {
                                label.text = "   " + (string ?? "")
                            }
                            else if existingText == "   -0" {
                                label.text = "   -" + (string ?? "")
                            }
                            else {
                                label.text = existingText + (string ?? "")
                            }
                        }
                    }
                    else {
                        label.text = "   "
                    }
                }
            }
        }
    }
    @IBAction func calc_operator1ButtonPressed(button: UIButton) {
        haptic()
        if button.tag == 19 {
            if let label = self.view.viewWithTag(1) as? UILabel {
                if let existingText = label.text {
                    if existingText.count >= 3 {
                        let modifiedExistingText = String(existingText.dropFirst(3))
                        firstNumber = Double(modifiedExistingText) ?? 0.0
                        label.text = "   " + String(pow(firstNumber, 0.5))
                        firstNumber = 0.0
                        secondNumber = 0.0
                    }
                }
            }
        }
        else {
            if activeOperator == 0 {
                activeOperator = button.tag
                checkOperator()
                enterSecondNumber = true
            }
            else if enterSecondNumber == true {
                activeOperator = button.tag
                checkOperator()
                enterSecondNumber = true
            }
        }
    }
    @IBAction func calc_operator2ButtonPressed(button: UIButton) {
        haptic()
        if traitCollection.userInterfaceStyle == .dark {
            button.backgroundColor = UIColor.systemGray
        }
        else {
            button.backgroundColor = UIColor.systemGray4
        }
        if button.tag == 20 {
            if let label = self.view.viewWithTag(1) as? UILabel {
                activeOperator = 0
                checkOperator()
                label.text = "   0"
            }
        }
        if button.tag == 21 {
            if enterSecondNumber == false {
                if let label = self.view.viewWithTag(1) as? UILabel {
                    if let existingText = label.text {
                        if existingText.count >= 3 {
                            let modifiedExistingText = String(existingText.dropFirst(3))
                            secondNumber = Double(modifiedExistingText) ?? 0.0
                        }
                    }
                    if activeOperator == 14 {
                        label.text = "   " + String(firstNumber + secondNumber)
                        activeOperator = 0
                        checkOperator()
                        firstNumber = 0.0
                        secondNumber = 0.0
                    }
                    if activeOperator == 15 {
                        label.text = "   " + String(firstNumber / secondNumber)
                        activeOperator = 0
                        checkOperator()
                        firstNumber = 0.0
                        secondNumber = 0.0
                    }
                    if activeOperator == 16 {
                        label.text = "   " + String(firstNumber - secondNumber)
                        activeOperator = 0
                        checkOperator()
                        firstNumber = 0.0
                        secondNumber = 0.0
                    }
                    if activeOperator == 17 {
                        label.text = "   " + String(pow(firstNumber, secondNumber))
                        activeOperator = 0
                        checkOperator()
                        firstNumber = 0.0
                        secondNumber = 0.0
                    }
                    if activeOperator == 18 {
                        label.text = "   " + String(firstNumber * secondNumber)
                        activeOperator = 0
                        checkOperator()
                        firstNumber = 0.0
                        secondNumber = 0.0
                    }
                }
            }
        }
        if button.tag == 25 {
            if let label = self.view.viewWithTag(1) as? UILabel {
                if let existingText = label.text {
                    if existingText.count >= 3 {
                        let modifiedExistingText = String(existingText.dropFirst(3))
                        (textDocumentProxy as UIKeyInput).insertText("\(modifiedExistingText)")
                    }
                }
            }
        }
    }
    @objc func checkOperator() {
        for i in 14...18 {
            if let button = self.view.viewWithTag(i) as? UIButton {
                if i == activeOperator {
                    if traitCollection.userInterfaceStyle == .dark {
                        button.backgroundColor = UIColor.systemGray
                    }
                    else {
                        button.backgroundColor = UIColor.systemGray4
                    }
                }
                else {
                    if traitCollection.userInterfaceStyle == .dark {
                        button.backgroundColor = UIColor.systemGray2
                    }
                    else {
                        button.backgroundColor = UIColor.white
                    }
                }
            }
        }
    }
    @IBAction func symbolsButtonPressed(button: UIButton) {
        haptic()
        let newNib = UINib(nibName: "SymbolKeyboardView", bundle: nil)
        if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
            view = newKeyboardView
            keyboardType = 2
            moveBackToEnglish = 0
            appearance()
        }
    }
    @IBAction func englishButtonPressed(button: UIButton) {
        haptic()
        if numberSwitched == true {
            let newNib = UINib(nibName: "CalcKeyboardView", bundle: nil)
            if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
                view = newKeyboardView
                keyboardType = 5
                moveBackToEnglish = 0
                appearance()
                numberSwitched = false
                firstNumber = 0.0
                secondNumber = 0.0
                enterSecondNumber = false
                activeOperator = 0
            }
        }
        else {
            let newNib = UINib(nibName: "EngKeyboardView", bundle: nil)
            if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
                view = newKeyboardView
                keyboardType = 1
                moveBackToEnglish = 0
                appearance()
                capsLock = false
            }
        }
    }
    @IBAction func mathButtonPressed(button: UIButton) {
        haptic()
        let newNib = UINib(nibName: "MathKeyboardView", bundle: nil)
        if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
            view = newKeyboardView
            keyboardType = 3
            moveBackToEnglish = 0
            appearance()
        }
    }
    @IBAction func supscrSubscrButtonPressed(button: UIButton) {
        haptic()
        let newNib = UINib(nibName: "SupscrSubscrKeyboardView", bundle: nil)
        if let newKeyboardView = newNib.instantiate(withOwner: self, options: nil).first as? UIView {
            view = newKeyboardView
            keyboardType = 4
            moveBackToEnglish = 0
            appearance()
        }
    }
        
    func appearance() {
        for subview in self.view.subviews {
            if let button = subview as? UIButton {
                if traitCollection.userInterfaceStyle == .dark {
                    button.backgroundColor = UIColor.systemGray2
                    button.configuration?.baseForegroundColor = UIColor.white
                }
                else {
                    button.backgroundColor = UIColor.white
                    button.configuration?.baseForegroundColor = UIColor.black
                }
                button.layer.cornerRadius = 3
                button.layer.masksToBounds = true
            }
            if let button2 = subview as? UIButton {
                if traitCollection.userInterfaceStyle == .dark {
                    button2.backgroundColor = UIColor.systemGray2
                    button2.configuration?.baseForegroundColor = UIColor.white
                }
                else {
                    button2.backgroundColor = UIColor.white
                    button2.configuration?.baseForegroundColor = UIColor.black
                }
                button2.layer.cornerRadius = 3
                button2.layer.masksToBounds = true
            }
            if let label = subview as? UILabel {
                if traitCollection.userInterfaceStyle == .dark {
                    label.textColor = UIColor.white
                    if keyboardType == 5 {
                        if let display = self.view.viewWithTag(1) as? UILabel {
                            display.backgroundColor = UIColor.systemGray3
                            display.layer.cornerRadius = 3
                            display.layer.masksToBounds = true
                        }
                    }
                }
                if traitCollection.userInterfaceStyle == .light {
                    label.textColor = UIColor.black
                    if keyboardType == 5 {
                        if let display = self.view.viewWithTag(1) as? UILabel {
                            display.backgroundColor = UIColor.systemGray5
                            display.layer.cornerRadius = 3
                            display.layer.masksToBounds = true
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
