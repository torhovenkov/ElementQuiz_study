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
    case score
}
class ViewController: UIViewController, UITextFieldDelegate {
    let fixedElementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var elementList: [String] = []
    var currentElementIndex = 0
    var mode: Mode = .flashCard {
        didSet {
            switch mode {
            case .flashCard: setupFlashCards()
            case .quiz: setupQuiz()
            }
            updateUI()
        }
    }
    var state: State = .question
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    //Setup a new flash card session
    func setupFlashCards() {
        state = .question
        currentElementIndex = 0
        elementList = fixedElementList
    }
    
    //Setup a new quiz session
    func setupQuiz() {
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
        elementList = fixedElementList.shuffled()
    }
    
    ///Updates the app's UI in flash card mode
    func updateFlashCardUI() {
        
        //buttons
        showAnswerButton.isHidden = false
        nextElementButton.isEnabled = true
        nextElementButton.setTitle("Next Element", for: .normal)
        
        //Segmented Control
        modeSelector.selectedSegmentIndex = 0
        answerLabel.text = "?"
        
        //Text field and keyboard
        textField.isHidden = true
        textField.resignFirstResponder()
        //Answer label
        if state == .answer {
            answerLabel.text = elementList[currentElementIndex]
        } else {
            answerLabel.text = "?"
        }
    }
    //Updates the app's UI in quiz mode
    func updateQuizUI() {
        //buttons
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextElementButton.setTitle("Show Result", for: .normal)
        } else {
            nextElementButton.setTitle("Next Question", for: .normal)
        }
        switch state {
        case .question:
            nextElementButton.isEnabled = false
        case .answer:
            nextElementButton.isEnabled = true
        case .score:
            nextElementButton.isEnabled = false
        }
        
        modeSelector.selectedSegmentIndex = 1
        textField.isHidden = false
        //Text Field and Keyboard
        switch state {
        case .question: //shows keyboard and cleans text field
            textField.becomeFirstResponder()
            textField.text = ""
        case .answer: //hides keyboard
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        //Answer Label
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
                textField.text = ""
            } else {
                answerLabel.text = "❌\nCorrect Answer: \(elementList[currentElementIndex])"
            }
        case .score:
            answerLabel.text = ""
            print("Your score is \(correctAnswerCount) out of \(elementList.count)")
        }
        if state == .score {
            displayScoreAlert()
        }
    }
    //Updates UI depends on mode state
    func updateUI(){
        //Updates image
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
    
    
    @IBOutlet weak var nextElementButton: UIButton!
    @IBAction func next(_ sender: UIButton) {
        currentElementIndex += 1
        if mode == .quiz {
            textField.isEnabled = true
        }
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
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
    
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBAction func showAnswer(_ sender: UIButton) {
        switch mode {
        case .flashCard:
            state = .answer
        case .quiz:
            state = .question
        }
       
//      checkAnswerInTextField()
        updateUI()
        
    }
    // Runs after the user hits the Return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Get the text from the text field
        let textFieldContents = textField.text!
        //Determine whether the user answered correctly and update appropriate quiz state
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            correctAnswerCount += 1
            //Disables text editing if answer is correct (will be enabled in next() method)
            textField.isEnabled = false
        } else {
            answerIsCorrect = false
        }
        state = .answer
        updateUI()
        return true
    }
    
    //Check if TextField contains correct answer and changes answeIsCorrect status
//    func checkAnswerInTextField() {
//        if textField.text?.lowercased() == elementList[currentElementIndex].lowercased() {
//            answerIsCorrect = true
//        }
//    }
    func displayScoreAlert() {
        let alert = UIAlertController(title: "Quiz Score", message: "Your score is \(correctAnswerCount) out of \(elementList.count).", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    func scoreAlertDismissed(_ action: UIAlertAction){
        mode = .flashCard
    }
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mode = .flashCard
        
    }


}

