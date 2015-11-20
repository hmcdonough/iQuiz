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
    
    @IBAction func clickSettingsButton(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        let newURLAction = UIAlertAction(title: "New Quiz", style: UIAlertActionStyle.Default) {
            (action) in
                self.newUrl()
        }
        alertController.addAction(newURLAction)

        let closeAction = UIAlertAction(title: "Back", style: UIAlertActionStyle.Cancel) {
            (action) in
        }
        alertController.addAction(closeAction)
        
        alertController.modalPresentationStyle = .Popover
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func newUrl() {
        let alertController = UIAlertController(title: "New Url", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Url"
        }
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel){
            (action) in
        }
        alertController.addAction(closeAction)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            (action) in
                let field = alertController.textFields!.first as? UITextField!
                self.defaults.setValue(field!.text, forKey: "url")
                self.jsonUrl = field!.text!
                self.connect()
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    var jsonUrl = "http://tednewardsandbox.site44.com/questions.json"
    var jsonData = NSMutableData()
    
    func connect() {
        let path : String = jsonUrl
        let url : NSURL = NSURL(string: path)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.jsonData.setData(data)
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()

    func connectionDidFinishLoading(connection: NSURLConnection!) {
//        var jsonResult: NSMutableArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSMutableArray
        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSMutableArray {
                quizzes = getJsonQuizzes(jsonResult)
                defaults.setObject(jsonResult, forKey: "quizList")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        } catch {
            print(error)
        }
    }

    class quizTemplate {
        var imageName: String!
        var title: String!
        var subtext: String!
        var test: quiz
        
        init(title: String, imageName: String, subtext: String, test: quiz){
            self.imageName = imageName
            self.title = title
            self.subtext = subtext
            self.test = test
        }
    }
    
    class question {
        var question: String!
        var answers: [String]!
        var answerIndex: Int!
        
        init(question: String, answers: [String], answerIndex: Int){
            self.question = question
            self.answers = answers
            self.answerIndex = answerIndex
        }
        
        func getCorrectString() -> String{
            return answers[answerIndex]
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

            let question1 = question(question: "What is 2 + 4?", answers: ["5", "6", "7", "8"], answerIndex: 1)
            let question2 = question(question: "What is 5 * 7?", answers: ["22", "43", "35", "50"], answerIndex: 2)
            let question3 = question(question: "What is 120 - 34?", answers: ["86", "90", "94", "98"], answerIndex: 0)
            
            let question4 = question(question: "Finish the name: 'Captian...'", answers: ["Liberty", "Freedom", "America", "Blart"], answerIndex: 2)
            let question5 = question(question: "What is the name of Tony Stark's A.I.?", answers: ["Jarvis", "Jeeves", "Jenkins", "All of the above"], answerIndex: 0)
            let question6 = question(question: "What super group is formed by marvel super heroes?", answers: ["Justice League", "Avengers", "Batman", "Nato"], answerIndex: 1)
            let question7 = question(question: "What bugs were featured in a 2015 Marvel movie?", answers: ["Ants", "Worms", "Termites", "Sasquatch"], answerIndex: 0)
            
            let question8 = question(question: "What state is ice in?", answers: ["Gas", "Liquid", "Solid", "Arkansas"], answerIndex: 2)
            
            let mathQuiz = quiz(questions: [question1, question2, question3])
            let marvelQuiz = quiz(questions: [question4, question5, question6, question7])
            let scienceQuiz = quiz(questions: [question8])

            
            let q1 = quizTemplate(title: "Math", imageName: "Math.jpg", subtext: "Challenge your arithmetic skills", test: mathQuiz)
            let q2 = quizTemplate(title: "Marvel Super Heroes", imageName: "marvel.jpeg", subtext: "Think you've got what it takes to challenge these superheroes?", test: marvelQuiz)
            let q3 = quizTemplate(title: "Science", imageName: "Science.jpg", subtext: "Don't trust banks, take science quizzes", test: scienceQuiz)
            
            quizzes.append(q1)
            quizzes.append(q2)
            quizzes.append(q3)
        }
        
        func getQuizzes() -> [quizTemplate] {
            return quizzes
        }
        
    }
    
    func getJsonQuizzes(data: NSMutableArray) -> [quizTemplate] {
        var importedQuizzes : [quizTemplate] = []
        
        for (var i = 0; i < data.count as Int; i++) {
            let newQuiz: AnyObject = data[i]
            var createdQuestions : [question] = []
            var receivedQuestions : [AnyObject] = newQuiz["questions"] as! [AnyObject]
            
            for (var j = 0; j < receivedQuestions.count; j++) {
                let newQuestion: AnyObject = receivedQuestions[j]
                let correct : Int = Int(newQuestion["answer"] as! String)! - 1
                let createdQuestion = question(question: newQuestion["text"] as! String, answers: newQuestion["answers"] as! [String], answerIndex: correct)
                
                createdQuestions.append(createdQuestion)
            }
            
            let createdQuiz = quizTemplate(title: newQuiz["title"] as! String, imageName: "", subtext: newQuiz["desc"] as! String, test: quiz(questions: createdQuestions))
            importedQuizzes.append(createdQuiz)
        }
        return importedQuizzes
    }
    
    let quizList = quizDataSource()
    var quizzes : [quizTemplate] = quizDataSource().getQuizzes()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.navigationItem.leftBarButtonItem = settingsButton
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//            
//        }
//        alertController.addAction(cancelAction)
//        
//        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//            
//        }
//        alertController.addAction(OKAction)
//        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.quizzes = quizList.getQuizzes()
        
        connect()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        
        // Load stored URL to get quizzes
        if let storedURL = defaults.stringForKey("url") {
            jsonUrl = storedURL
        }
        
        // Load previously saved quizzes in case of no internet connection
        if let storedObjects: AnyObject = defaults.objectForKey("quizList") {
            quizzes = getJsonQuizzes(storedObjects as! NSMutableArray)
        }
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
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.quizSet = self.quizzes[indexPath.row].test
                controller.quizCount = 0
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

