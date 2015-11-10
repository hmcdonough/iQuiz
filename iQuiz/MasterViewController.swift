//
//  MasterViewController.swift
//  iQuiz
//
//  Created by Harry McDonough on 11/2/15.
//  Copyright © 2015 Harrison McDonough. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    let alertController = UIAlertController(title: "Settings Go Here", message: "Okie Dokie", preferredStyle: .Alert)

    @IBAction func clickSettingsButton(sender: AnyObject) {
        self.presentViewController(alertController, animated: true) {
            
        }
    }

    class quizTemplate {
        var imageName: String!
        var title: String!
        var subtext: String!
        
        init(title: String, imageName: String, subtext: String){
            self.imageName = imageName
            self.title = title
            self.subtext = subtext
        }
    }
    
    class question {
        var question: String!
        var answers: [String]!
        var answerIndex: Int!
        
        init(question: String, answers: [String], answerIndex: Int){
            self.question = question
            self.answers = answers
        }
    }
    
    class quiz {
        var questions: [question]!
        
        init(questions: [question]){
            self.questions = questions
        }
    }
    
    class quizDataSource {
        var quizzes:[quizTemplate]
        
        init() {
            quizzes = []
            
            let q1 = quizTemplate(title: "Math", imageName: "Math.jpg", subtext: "Challenge your arithmetic skills")
            let q2 = quizTemplate(title: "Marvel Super Heroes", imageName: "marvel.jpeg", subtext: "Think you've got what it takes to challenge these superheroes?")
            let q3 = quizTemplate(title: "Science", imageName: "Science.jpg", subtext: "Don't trust banks, take science quizzes")

            quizzes.append(q1)
            quizzes.append(q2)
            quizzes.append(q3)
        }
        
        func getQuizzes() -> [quizTemplate] {
            return quizzes
        }
        
    }
    
    let quizList = quizDataSource()
    var quizzes : [quizTemplate] = quizDataSource().getQuizzes()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.navigationItem.leftBarButtonItem = settingsButton
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        alertController.addAction(OKAction)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.quizzes = quizList.getQuizzes()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        let context = self.fetchedResultsController.managedObjectContext
//        let entity = self.fetchedResultsController.fetchRequest.entity!
//        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
//             
//        // If appropriate, configure the new managed object.
//        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
//             
//        // Save the context.
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            //print("Unresolved error \(error), \(error.userInfo)")
//            abort()
//        }
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let question1 = question(question: "What is 2 + 4?", answers: ["5", "6", "7"], answerIndex: 2)
        let question2 = question(question: "What is 5 * 7?", answers: ["22", "43", "35"], answerIndex: 3)
        let question3 = question(question: "What is 120 - 34?", answers: ["86", "90", "94"], answerIndex: 1)
        
        let question4 = question(question: "Finish the name: 'Captian...'", answers: ["Liberty", "Freedom", "America"], answerIndex: 3)
        let question5 = question(question: "What is the name of Tony Stark's A.I.?", answers: ["Jarvis", "Jeeves", "Jenkins"], answerIndex: 1)
        let question6 = question(question: "What super group is formed by marvel super heroes?", answers: ["Justice League", "Avengers", "Batman"], answerIndex: 2)
        let question7 = question(question: "What bugs were featured in a 2015 Marvel movie?", answers: ["Ants", "Worms", "Termites"], answerIndex: 1)
        
        let question8 = question(question: "What state is ice in?", answers: ["Gas", "Liquid", "Solid"], answerIndex: 3)
        
        let mathQuiz = quiz(questions: [question1, question2, question3])
        let marvelQuiz = quiz(questions: [question4, question5, question6, question7])
        let scienceQuiz = quiz(questions: [question8])
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.quizSet = mathQuiz
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let quiz = self.quizzes[indexPath.row]
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.subtext
        cell.imageView?.image = UIImage(named: quiz.imageName)
        return cell
    }
}

