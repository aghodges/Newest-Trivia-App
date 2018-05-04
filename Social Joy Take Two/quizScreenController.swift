//
//  quizScreenController.swift
//  Social Joy
//
//  Created by Addison G Hodges on 5/1/18.
//  Copyright © 2018 Cohen, Trevor (Genworth). All rights reserved.
//


//Using semaphora so that the JSON Request will go through before setting up Question
//Need to set Allows Arbitrary Loads in pList to YES -- Important, otherwise code won't work

import MultipeerConnectivity
import UIKit

class quizScreenController: UIViewController {
    
    
    var browser: MCBrowserViewController!
    var session: MCSession!
    var peerID: MCPeerID!
    var currentPlayer : Player!
    
    let semaphore = DispatchSemaphore(value: 0)
    
    
    
    
    //    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var timer = Timer()
    var timerIsRunning = false
    var seconds = 20
    
    
    //    var nextQuizNumber = 0
    //    var jsonQuestions:Question!
    //    var topic = ""
    //    var jsonQuestion = [Question]()
    //    var number = 0
    //    var numQuestions = 0
    //    var question = ""
    //    var answer = ""
    //    var options = [String:String]()
    //
    var numberOfQuestions = 0
    var questionTopic = ""
    var questionNumber = 0
    var question = ""
    var questionAnswer = ""
    var questionChoices = [String:String]()
    
    var jsonQuestions: Question!
    var jsonQuestion = [Question]()
    
    
    var questionCount = 0
    
    var currentQuestion = 0
    
    
    
    
    
    //    @IBOutlet weak var questionLabel: UILabel!
    //
    //    @IBOutlet weak var choiceA: UIButton!
    //    @IBOutlet weak var choiceB: UIButton!
    //    @IBOutlet weak var choiceC: UIButton!
    //    @IBOutlet weak var choiceD: UIButton!
    //
    //    @IBOutlet weak var playerOneScore: UILabel!
    //    @IBOutlet weak var playerTwoScore: UILabel!
    //    @IBOutlet weak var playerThreeScore: UILabel!
    //    @IBOutlet weak var playerFourScore: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var choiceA: UIButton!
    @IBOutlet weak var choiceB: UIButton!
    @IBOutlet weak var choiceC: UIButton!
    @IBOutlet weak var choiceD: UIButton!
    
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var player3Score: UILabel!
    @IBOutlet weak var player4Score: UILabel!
    
    var playerOneCount = Int()
    var playerTwoCount = Int()
    var playerThreeCount = Int()
    var playerFourCount = Int()
    
    
    
    
    @IBAction func choiceASelect(_ sender: Any) {
        choiceA.backgroundColor = UIColor.blue
        choiceB.backgroundColor = UIColor.gray
        choiceC.backgroundColor = UIColor.gray
        choiceD.backgroundColor = UIColor.gray
        
        currentPlayer.playerAnswer = "A"
        print("current player: " + currentPlayer.peerID + " answered " + currentPlayer.playerAnswer)
    }
    
    
    @IBAction func choiceBSelect(_ sender: Any) {
        choiceB.backgroundColor = UIColor.blue
        choiceA.backgroundColor = UIColor.gray
        choiceC.backgroundColor = UIColor.gray
        choiceD.backgroundColor = UIColor.gray
        
        currentPlayer.playerAnswer = "B"
        print("current player: " + currentPlayer.peerID + " answered " + currentPlayer.playerAnswer)
        
        
    }
    
    
    
    @IBAction func choiceCSelect(_ sender: Any) {
        choiceC.backgroundColor = UIColor.blue
        choiceA.backgroundColor = UIColor.gray
        choiceB.backgroundColor = UIColor.gray
        choiceD.backgroundColor = UIColor.gray
        
        currentPlayer.playerAnswer = "C"
        print("current player: " + currentPlayer.peerID + " answered " + currentPlayer.playerAnswer)
        
        
    }
    
    @IBAction func choiceDSelect(_ sender: Any) {
        choiceD.backgroundColor = UIColor.blue
        choiceA.backgroundColor = UIColor.gray
        choiceB.backgroundColor = UIColor.gray
        choiceC.backgroundColor = UIColor.gray
        
        currentPlayer.playerAnswer = "D"
        print("current player: " + currentPlayer.peerID + " answered " + currentPlayer.playerAnswer)
        
        
        
    }
    
    
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(quizScreenController.updateTheTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTheTimer()
    {
        seconds = seconds - 1
        timeLabel.text = "\(seconds)"
        
        if seconds == 0
        {
            timer.invalidate()
            
            endQuestion()
        }
        
        if haveAllPlayersAnswered() == true
        {
            endQuestion()
        }
        
        
        
        
    }
    
    func haveAllPlayersAnswered() -> Bool
    {
        var playerCount = thePlayers.count
        var i = 0
        var playersAnswered = 0
        
        while i != playerCount
        {
            if thePlayers[i].playerAnswer != ""
            {
                playersAnswered = playersAnswered + 1
            }
            i = i + 1
        }
        
        if playerCount == playersAnswered
        {
            return true
        }
        else {
            return false
        }
      
    }
    
    func endQuestion()
    {
        var correctAnswer = jsonQuestion[currentQuestion].answer
        
        if currentPlayer.playerAnswer == correctAnswer
        {
            questionLabel.text = "Correct! The answer was " + jsonQuestion[currentQuestion].choices[correctAnswer]!
            awardPoints(currentPlayer: currentPlayer)
            
        }
        else if currentPlayer.playerAnswer != correctAnswer
        {
            questionLabel.text = "Incorrect. The answer was " + jsonQuestion[currentQuestion].choices[correctAnswer]!
        }
        else {
            print("Something went wrong!")
        }
        
        currentQuestion = currentQuestion + 1
        goToNextQuestion()
        
    }
    
    func awardPoints(currentPlayer : Player)
    {
    
        if currentPlayer.playerNumber == "1"
        {
            playerOneCount = playerOneCount + 1
            player1Score.text = String(playerOneCount)
        }
        else if currentPlayer.playerNumber == "2"
        {
            playerTwoCount = playerTwoCount + 1
            player2Score.text = String(playerTwoCount)
        }
        else if currentPlayer.playerAnswer == "3"
        {
            playerThreeCount = playerThreeCount + 1
            player3Score.text = String(playerThreeCount)
        }
        else if currentPlayer.playerAnswer == "4"
        {
            playerFourCount = playerFourCount + 1
            player4Score.text = String(playerFourCount)
        }
        
    }
    
    func goToNextQuestion()
    {
        //Reset Question Label to current question
        //Reset correctAnswer
        //Reset playerAnswer
        //Reset timer to 20 seconds
        //Reset choices background colors all to gray
        
        setUpQuestion(number: currentQuestion)
        currentPlayer.playerAnswer = ""
        startTimer()
        
        choiceA.backgroundColor = UIColor.gray
        choiceB.backgroundColor = UIColor.gray
        choiceC.backgroundColor = UIColor.gray
        choiceD.backgroundColor = UIColor.gray

        
    }

    func setUpQuestion(number : Int)
    {
        questionLabel.text = jsonQuestion[number].question
        choiceA.setTitle(jsonQuestion[number].choices["A"], for: .normal)
        choiceB.setTitle(jsonQuestion[number].choices["B"], for: .normal)
        choiceC.setTitle(jsonQuestion[number].choices["C"], for: .normal)
        choiceD.setTitle(jsonQuestion[number].choices["D"], for: .normal)
        
        if currentQuestion != 0
        {
        currentQuestion = currentQuestion + 1
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        jsonQuestion = loadJSON() //Do we need to set jsonQuestion equal to this??
        
        //Multi-Line question Label
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 4
        
        
        setUpQuestion(number: 0)
        
        startTimer()
        
        
        
        
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        
     
        
        if peerID.displayName == thePlayers[0].peerID
        {
            currentPlayer = thePlayers[0]
        }
        else if thePlayers.count >= 1 && peerID.displayName == thePlayers[1].peerID
        {
            currentPlayer = thePlayers[1]
        }
        else if thePlayers.count >= 2 && peerID.displayName == thePlayers[2].peerID
        {
            currentPlayer = thePlayers[2]
        }
        else if thePlayers.count >= 3 && peerID.displayName == thePlayers[3].peerID
        {
            currentPlayer = thePlayers[3]
        }
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func loadJSON()-> [Question]    {
        var jsonURL = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json"
        let url = URL(string: jsonURL)
        let jsonSession = URLSession.shared
        
        let task = jsonSession.dataTask(with: url!, completionHandler: {(data,response,error) in
            if let result = data {
                print("Inside JSON")
                do {
                    let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                    
                    if let dictionary = json as? [String:Any] {
                        self.numberOfQuestions = dictionary["numberOfQuestions"] as! Int
                        self.questionTopic = dictionary["topic"] as! String
                        
                        let questions = dictionary["questions"] as! [Any]
                        questions.forEach({ (question) in
                            let q: [String:Any] = question as! [String : Any]
                            self.questionNumber = q["number"] as! Int
                            self.question = q["questionSentence"] as! String
                            self.questionAnswer = q["correctOption"] as! String
                            self.questionChoices = q["options"] as! [String:String]
                            var optionsForAnswers = [String:String]()
                            self.questionChoices.forEach({ (key, option) in
                                optionsForAnswers[key] = option
                            })
                            self.jsonQuestion.append(Question(question: self.question, choices: self.questionChoices, answer: self.questionAnswer, number: self.questionNumber))
                        })
                        self.semaphore.signal()
                        
                    }
                }
                catch {
                    print("Json can't be found")
                    self.semaphore.signal()
                    
                }
            }
        })
        
        task.resume()
        _ = self.semaphore.wait(timeout: .distantFuture)
        
        
        return jsonQuestion
    }
    
    
}

