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

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var submitQuestion: UIButton!
    var quizSet : MasterViewController.quiz = MasterViewController.quiz(questions: [])
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextFinish: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!

    
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
//        self.picker.dataSource = self
        print(quizSet.questions[0].question)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

