//
//  ViewController.swift
//  QuizzerApp
//
//  Created by Ken on 2016-10-29.
//  Copyright © 2016 Ken Suong (991380633) and Jaimin Patel (9913707807). All rights reserved.
//

import AVFoundation
import UIKit


struct Question {
    var Question: String!
    var Answers : [String]!
    var AnswerStringForm : String!
    var Picture : String!
    
    func getAnswer() -> Int {
        return Answers.indexOf(AnswerStringForm)!
    }
}

class ViewController: UIViewController {

    @IBOutlet var QuestionLabel: UILabel!
    @IBOutlet var QuestionAnswerButton: [UIButton]!
    @IBOutlet var CorrectOrIncorrectLabel: UILabel!
    @IBOutlet var CorrectScoreLabel: UILabel!
    @IBOutlet var IncorrectScoreLabel: UILabel!
    @IBOutlet var ImageForQuestion: UIImageView!
    @IBOutlet var QuestionOutOfLabel: UILabel!
    
    @IBOutlet var QuestionSegControl: UISegmentedControl!
    var QuestionAnswered = false
    var CorrectScore = 0
    var IncorrectScore = 0
    
    var Questions = [Question]()
    
    var QuestionNumber = Int()
    
    var AnswerNumber = Int()
    
    var testingString = String()
    
    var QuestionAnsweredCount = 0
    
    var QuestionCountBeginning = Int()
    
    var audioPlayer = AVAudioPlayer()

    var CorrectAlertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Ding", ofType: "wav")!)
    
    func CorrectAudioPlayerTryCatch() {
        do { try audioPlayer = AVAudioPlayer(contentsOfURL: CorrectAlertSound, fileTypeHint: nil)}
        catch let error as NSError {NSLog(error.description) }
    }
    
    var IncorrectAlertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Wrong", ofType: "mp3")!)
    
    func IncorrectAudioPlayerTryCatch() {
        do { try audioPlayer = AVAudioPlayer(contentsOfURL: IncorrectAlertSound, fileTypeHint: nil)}
        catch let error as NSError {NSLog(error.description) }
    }
    
    override func viewDidLoad() {
        CorrectScore = 0
        IncorrectScore = 0
        CorrectScoreLabel.hidden = true
        IncorrectScoreLabel.hidden = true
        QuestionAnsweredCount = 0
        Questions = [
            Question(Question: "What is the brand of this car?", Answers: ["BMW","Ford","Ferrari","Lexus"], AnswerStringForm: "BMW", Picture: "bmw"),
            Question(Question: "What is the name of this flag?", Answers: ["Canada","USA","Italy","France"], AnswerStringForm: "Canada", Picture: "canadaFlag"),
            Question(Question: "What is the name of this food?", Answers: ["Pizza","Steak","Pasta","Soup"], AnswerStringForm: "Pasta", Picture: "pasta"),
            Question(Question: "What is the brand of this car?", Answers: ["Mercedes","Honda","Toyota","Lexus"], AnswerStringForm: "Mercedes", Picture: "mercedes"),
            Question(Question: "What is the name of this award?", Answers: ["Oscar","Emmy","Grammy","Tony"], AnswerStringForm: "Oscar", Picture: "academyAward"),
            Question(Question: "Who founded this equation?", Answers: ["Issac Newton","Albert Einstein","Stephen Hawking","Thomas Edison"], AnswerStringForm: "Albert Einstein", Picture: "emc2"),
            Question(Question: "What is the name of this guy?", Answers: ["Alfred Hitchcock","Stanley Kubrick","James Cameron","Martin Scorsese"], AnswerStringForm: "Martin Scorsese", Picture: "martinScorsese"),
            Question(Question: "What is the name of this body part?", Answers: ["Nose","Eyes","Mouth","Ears"], AnswerStringForm: "Nose", Picture: "nose"),
            Question(Question: "What is the name of this baseball team?", Answers: ["Toronto Blue Jays","New York Yankees","Chicago Cubs","Baltimore Orioles"], AnswerStringForm: "Toronto Blue Jays", Picture: "torontoBlueJays"),
            Question(Question: "What is the breed of this dog?", Answers: ["Labrador Retriever","Golden Retriever","Bulldog","Pitbull"], AnswerStringForm: "Labrador Retriever", Picture: "labrador_retriever")
        ]
        
        QuestionCountBeginning = Questions.count
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        Hide()
        ShowQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShowQuestion() {
        QuestionSegControl.selectedSegmentIndex = -1
        if Questions.count > 0 {
            QuestionNumber = Int(arc4random()) % Questions.count
            QuestionLabel.text = Questions[QuestionNumber].Question
            ImageForQuestion.image = UIImage(named:Questions[QuestionNumber].Picture)
            for i in 0..<QuestionAnswerButton.count {
                let answerOrder = Int(arc4random()) % Questions[QuestionNumber].Answers.count
                QuestionAnswerButton[i].setTitle(Questions[QuestionNumber].Answers[answerOrder], forState: UIControlState.Normal)
                
                // For seg control
                QuestionSegControl.setTitle(Questions[QuestionNumber].Answers[answerOrder], forSegmentAtIndex: i)
                
                
                
                if Questions[QuestionNumber].Answers[answerOrder] == Questions[QuestionNumber].AnswerStringForm {
                    AnswerNumber = i
                }
                Questions[QuestionNumber].Answers.removeAtIndex(answerOrder)
                NSLog((QuestionAnswerButton[i].titleLabel?.text)!)
                
            }
            
//            for i in 0..<QuestionAnswerButton.count {
//                NSLog(String(QuestionAnswerButton.count))
//                let answerOrder = Int(arc4random()) % Questions[QuestionNumber].Answers.count
//                
//                // For seg control
//                QuestionSegControl.setTitle(Questions[QuestionNumber].Answers[answerOrder], forSegmentAtIndex: i)
//                
//                
//                
//                if Questions[QuestionNumber].Answers[answerOrder] == Questions[QuestionNumber].AnswerStringForm {
//                    AnswerNumber = i
//                }
//                Questions[QuestionNumber].Answers.removeAtIndex(answerOrder)
//                NSLog((QuestionAnswerButton[i].titleLabel?.text)!)
//                
//            }

            
            QuestionAnsweredCount += 1
            QuestionOutOfLabel.text = "Question \(QuestionAnsweredCount) out of \(QuestionCountBeginning)"
            Questions.removeAtIndex(QuestionNumber) // take away question when everything is loaded up to prevent repetition

        } else {
            let FinalScore = (Double(CorrectScore) / Double(QuestionCountBeginning)) * 100
            
            NSLog(String(CorrectScore))
            NSLog(String(FinalScore))
            NSLog(String(QuestionCountBeginning))
            
            let alertController = UIAlertController(title: "Results", message: "\(String(CorrectScore)) Correct \n \(String(IncorrectScore)) Guesses \n Final Score \(String(FinalScore))%", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) in
                self.viewDidLoad()
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func answerCorrect() {

        CorrectOrIncorrectLabel.hidden = false
        CorrectOrIncorrectLabel.text = "Correct Answer"
        CorrectOrIncorrectLabel.textColor = UIColor.greenColor()
        if QuestionAnswered == false {
            CorrectScore += 1
            NSLog(String(CorrectScore))
        }
        CorrectScoreLabel.text = "Correct Score: \(String(CorrectScore))"
        QuestionAnswered = false
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1))
        dispatch_after(delayTime, dispatch_get_main_queue()){
            self.CorrectOrIncorrectLabel.hidden = true
        }
        ShowQuestion()
    }
    
    func answerIncorrect() {
        CorrectOrIncorrectLabel.hidden = false
        CorrectOrIncorrectLabel.text = "Incorrect Answer"
        CorrectOrIncorrectLabel.textColor = UIColor.redColor()
 
            IncorrectScore += 1
        NSLog(String(IncorrectScore))
        IncorrectScoreLabel.text = "Incorrect Score: \(String(IncorrectScore))"
        QuestionAnswered = true
    }
    
    func Hide() {
        CorrectOrIncorrectLabel.hidden = true
    }

    @IBAction func QuestionOption1Action(sender: AnyObject) {
        if AnswerNumber == 0 {
            CorrectAudioPlayerTryCatch()
            audioPlayer.play()
            answerCorrect()
        } else {
            IncorrectAudioPlayerTryCatch()
            audioPlayer.play()
            answerIncorrect()
        }
    }

    @IBAction func QuestionOption2Action(sender: AnyObject) {
        if AnswerNumber == 1 {
            CorrectAudioPlayerTryCatch()
            audioPlayer.play()
            answerCorrect()
        } else {
            IncorrectAudioPlayerTryCatch()
            audioPlayer.play()
            answerIncorrect()
        }
    }

    @IBAction func QuestionOption3Action(sender: AnyObject) {
        if AnswerNumber == 2 {
            CorrectAudioPlayerTryCatch()
            audioPlayer.play()
            answerCorrect()
        } else {
            IncorrectAudioPlayerTryCatch()
            audioPlayer.play()
            answerIncorrect()
        }
    }
    
    @IBAction func QuestionOption4Action(sender: AnyObject) {
        if AnswerNumber == 3 {
            CorrectAudioPlayerTryCatch()
            audioPlayer.play()
            answerCorrect()
        } else {
            IncorrectAudioPlayerTryCatch()
            audioPlayer.play()
            answerIncorrect()
        }
    }
    
    
//    @IBAction func QuestionSegControlAction(sender: AnyObject) {
//        switch (sender.selectedSegmentIndex) {
//        case 0:
//            if AnswerNumber == 0 {
//                CorrectAudioPlayerTryCatch()
//                audioPlayer.play()
//                answerCorrect()
//            } else {
//                IncorrectAudioPlayerTryCatch()
//                audioPlayer.play()
//                answerIncorrect()
//            }
//            break;
//        case 1:
//            if AnswerNumber == 1 {
//                CorrectAudioPlayerTryCatch()
//                audioPlayer.play()
//                answerCorrect()
//            } else {
//                IncorrectAudioPlayerTryCatch()
//                audioPlayer.play()
//                answerIncorrect()
//            }
//            break;
//        case 2:
//            if AnswerNumber == 2 {
//                CorrectAudioPlayerTryCatch()
//                audioPlayer.play()
//                answerCorrect()
//            } else {
//                IncorrectAudioPlayerTryCatch()
//                audioPlayer.play()
//                answerIncorrect()
//            }
//            break;
//        case 3:
//            if AnswerNumber == 3 {
//                CorrectAudioPlayerTryCatch()
//                audioPlayer.play()
//                answerCorrect()
//            } else {
//                IncorrectAudioPlayerTryCatch()
//                audioPlayer.play()
//                answerIncorrect()
//            }
//            break;
//        default:
//            break;
//        }
//        
//    }
    
    
    
    
}

