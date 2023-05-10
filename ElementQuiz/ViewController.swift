//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Vladyslav Torhovenkov on 09.05.2023.
//

import UIKit
enum Mode {
    case flashCard
    case quiz
}
enum State {
    case question
    case answer
}
class ViewController: UIViewController, UITextFieldDelegate {
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    var mode: Mode = .flashCard {
        didSet {
            updateUI()
        }
    }
    var state: State = .question
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    ///Updates the app's UI in flash card mode
    func updateFlashCardUI() {
        
        answerLabel.text = "?"
        if state == .answer {
            answerLabel.text = elementList[currentElementIndex]
        } else {
            answerLabel.text = "?"
        }
    }
    
    func updateQuizUI() {
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            } else {
                answerLabel.text = "❌"
            }
        }
    }
    
    func updateUI(){
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        switch mode {
        case .flashCard:
            updateFlashCardUI()
        case .quiz:
            updateQuizUI()
        }
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
        }
        state = .question
        updateUI()
    }
    
    @IBAction func switchModes(_ sender: UISegmentedControl) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        state = .answer
        updateUI()
        
    }
    // Runs after the user hits the Return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Get the text from the text field
        let textFieldContents = textField.text!
        //Determine whether the user answered correctly and update appropriate quiz state
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            print("Correct")
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
            print("NAH")
        }
        state = .answer
        updateUI()
        return true
    }
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
        
    }


}

