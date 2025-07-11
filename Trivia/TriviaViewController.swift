//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {

    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!

    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        questionContainerView.layer.cornerRadius = 8.0

        TriviaQuestionService().fetchQuestions { [weak self] questions in
            guard let self = self, let questions = questions else { return }
            DispatchQueue.main.async {
                self.questions = questions
                self.currQuestionIndex = 0
                self.numCorrectQuestions = 0
                self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
            }
        }
    }

    private func updateQuestion(withQuestionIndex index: Int) {
        currentQuestionNumberLabel.text = "Question: \(index + 1)/\(questions.count)"
        let question = questions[index]
        questionLabel.text = decodeHTMLEntities(question.question)
        categoryLabel.text = question.category

        let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
        let buttons = [answerButton0, answerButton1, answerButton2, answerButton3]

        for (i, button) in buttons.enumerated() {
            if i < answers.count {
                button?.setTitle(decodeHTMLEntities(answers[i]), for: .normal)
                button?.isHidden = false
            } else {
                button?.isHidden = true
            }
        }
    }

    private func updateToNextQuestion(answer: String) {
        if isCorrectAnswer(answer) {
            numCorrectQuestions += 1
        }
        currQuestionIndex += 1
        guard currQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        updateQuestion(withQuestionIndex: currQuestionIndex)
    }

    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == questions[currQuestionIndex].correctAnswer
    }

    private func showFinalScore() {
        let alert = UIAlertController(title: "Game Over", message: "Score: \(numCorrectQuestions)/\(questions.count)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { _ in
            self.currQuestionIndex = 0
            self.numCorrectQuestions = 0
            TriviaQuestionService().fetchQuestions { [weak self] questions in
                guard let self = self, let questions = questions else { return }
                DispatchQueue.main.async {
                    self.questions = questions
                    self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
                }
            }
        })
        present(alert, animated: true)
    }

    private func decodeHTMLEntities(_ string: String) -> String {
        guard let data = string.data(using: .utf8) else { return string }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html
        ]
        if let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributed.string
        }
        return string
    }

    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
}
