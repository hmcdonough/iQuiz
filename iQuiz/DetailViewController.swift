//
//  DetailViewController.swift
//  iQuiz
//
//  Created by Harry McDonough on 11/2/15.
//  Copyright © 2015 Harrison McDonough. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    //views
    @IBOutlet var qView: UIView!
    @IBOutlet var resultView: UIView!
    @IBOutlet var totalView: UIView!

    //qView
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var submitQuestion: UIButton!

    //resultView
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultQuestionLabel: UILabel!
    @IBOutlet weak var resultAnswerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    //totalView
    @IBOutlet weak var descriptiveLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var Next: UIButton!
    
    //tracker vars
    var quizSet : MasterViewController.quiz = MasterViewController.quiz(questions: [])
    var quizCount : Int = 0
    var pickerData = []
    var selection : Int = 0
    var correctAnswers : Int = 0
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("timeStamp")!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        if (totalView != nil){
            var descript = ""
            let score : Double = Double(correctAnswers) / Double(quizSet.questions.count)
            if (score == 1) {
                descript = "Perfect!"
            } else if (score > 0.49) {
                descript = "Alright!"
            } else {
                descript = "Not Good!"
            }
            descriptiveLabel.text = descript
            scoreLabel.text = "You scored " + String(correctAnswers) + "/" + String(quizSet.questions.count)
        } else {
            let question = quizSet.questions[quizCount]
            if (resultView != nil) {
                if (quizCount < quizSet.questions.count - 1) {
                    self.finishButton.hidden = true
                } else {
                    self.nextButton.hidden = true
                }
                
                quizCount++
                resultLabel.text = question.answers[question.answerIndex]
                resultQuestionLabel.text = question.question
                resultAnswerLabel.text = "Answer: " + String(question.answers[question.answerIndex])

                if (selection == question.answerIndex) {
                    correctAnswers++
                    resultLabel.text = "Correct"
                } else{
                    resultLabel.text = "Incorrect"
                }
            } else if (qView != nil) {
                questionLabel.text = question.question
                pickerData = quizSet.questions[quizCount].answers
            }
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quizSet.questions[quizCount].answers.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row] as! String
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let barItem = sender as? UIBarButtonItem {
        } else {
            if (qView != nil) {
                selection = picker.selectedRowInComponent(0)
            }
            if (totalView == nil) {
                let controller = segue.destinationViewController as! DetailViewController
                controller.selection = selection
                controller.correctAnswers = correctAnswers
                controller.quizSet = quizSet
                controller.quizCount = quizCount
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

