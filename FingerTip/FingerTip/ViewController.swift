//
//  ViewController.swift
//  FingerTip
//
//  Created by Student on 2019-10-04.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
    var gameManager : GameManager = GameManager()
    
    @IBOutlet weak var labelRandomNumber: UILabel!
    @IBOutlet weak var labelMessages: UILabel!
    @IBOutlet weak var labelShowScore: UILabel!
    @IBOutlet weak var labelSliderMaxValue: UILabel!
    @IBOutlet weak var sliderGuessedValue: UISlider!
    @IBOutlet weak var buttonLevel1: UIButton!
    @IBOutlet weak var buttonLevel2: UIButton!
    @IBOutlet weak var buttonLevel3: UIButton!
    @IBOutlet weak var buttonReset: UIButton!
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var buttonTry: UIButton!
    @IBOutlet weak var labelHighScore: UILabel!
    
    @IBAction func sliderGuessedValueChanged(_ sender: UISlider) {
        gameManager.guessedValue = Int(round(sender.value))
    }
    
    @IBAction func buttonLevel1Clicked(_ sender: UIButton) {
        changeLevel(to: .Level1)
    }
    
    @IBAction func buttonLevel2Clicked(_ sender: UIButton) {
        changeLevel(to: .Level2)
    }
    
    @IBAction func buttonLevel3Clicked(_ sender: UIButton) {
        changeLevel(to: .Level3)
    }
    
    @IBAction func buttonTryClicked(_ sender: UIButton) {
        labelMessages.text = "Click 'Check' to get score"
        gameManager.randomNumber = Int.random(in: 0...gameManager.maxRange)
        labelRandomNumber.text = String(gameManager.randomNumber!)
    }
    
    @IBAction func buttonCheckClicked(_ sender: UIButton) {
        labelMessages.text = ""
        if gameManager.randomNumber == nil {
            labelMessages.text = "Click 'Try' to start"
        }
        else {
            gameManager.increaseScore()
            labelShowScore.text = "Score = \(gameManager.score) Total score = \(gameManager.totalScore)"
            labelMessages.text = "Click 'Try' to start"
            setSlider()
            labelRandomNumber.text = ""
        }
    }
    
    @IBAction func buttonResetClicked(_ sender: Any) {
        gameManager.changeLevel(to: .Level1)
        gameManager.totalScore = 0
        gameManager.highScore = 0
        
        reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reset()
        
        setRadius(to: labelRandomNumber)
        setRadius(to: labelMessages)
        setRadius(to: buttonLevel1)
        setRadius(to: buttonLevel2)
        setRadius(to: buttonLevel3)
        setRadius(to: buttonTry)
        setRadius(to: buttonCheck)
        setRadius(to: buttonReset)
        setRadius(to: labelShowScore)
    }
    
    func changeLevel(to level : GameLevel) {
        gameManager.randomNumber = nil
        gameManager.changeLevel(to: level)
        changeButtonColor(for: level)
        setSlider()
        labelMessages.text = "Click 'Try' to start"
        labelRandomNumber.text = ""
    }
    
    func reset() {
        setSlider()
        labelMessages.text = "Click 'Try' to start"
        changeButtonColor(for: .Level1)
        labelShowScore.text = "Score = 0 Total score = 0"
    }
    
    func setRadius(to control: UIView) {
        control.layer.cornerRadius = 5
        control.clipsToBounds = true
    }
    
    func changeButtonColor(for level : GameLevel){
        buttonLevel1.setTitleColor(level == .Level1 ? .red : .black, for: .normal)
        buttonLevel2.setTitleColor(level == .Level2 ? .red : .black, for: .normal)
        buttonLevel3.setTitleColor(level == .Level3 ? .red : .black, for: .normal)
    }
    
    func setSlider() {
        sliderGuessedValue.maximumValue = Float(gameManager.maxRange)
        sliderGuessedValue.value = Float(gameManager.guessedValue)
        labelSliderMaxValue.text = String(gameManager.maxRange)
        labelHighScore.text = "High score = \(String(gameManager.highScore))"
    }
    
    enum GameLevel {
        case Level1
        case Level2
        case Level3
    }
    
    class GameManager {
        var level : GameLevel = .Level1
        var randomNumber : Int?
        var score : Int
        var totalScore : Int
        var guessedValue : Int = 5
        var highScore : Int
        
        var maxRange : Int {
            switch level {
                case .Level1:
                    return 10
                case .Level2:
                    return 100
                case .Level3:
                    return 500
            }
        }
        
        init() {
            level = .Level1
            randomNumber = nil
            score = 0
            totalScore = 0
            highScore = 0
            guessedValue = self.calcInitialValue()
        }
        
        func changeLevel(to level : GameLevel) {
            self.level = level
            guessedValue = self.calcInitialValue()
        }
        
        func calcInitialValue() -> Int {
            return maxRange / 2
        }
        
        func increaseScore() {
            score = calcScore()
            totalScore += score
            
            if score > highScore {
                highScore = score
            }
            
            randomNumber = nil
            guessedValue = self.calcInitialValue()
        }
        
        func calcScore() -> Int {
            let floatValue = Float(maxRange - abs(guessedValue - randomNumber!)) / Float(maxRange)
            
            return Int(floatValue * 100)
        }
    }
}
