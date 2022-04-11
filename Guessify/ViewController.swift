/*
* FILE                 :    ViewController.swift
* PROJECT              :    PROG3230 (Mobile Application Development I) - Project 1
* PROGRAMMER           :    Kenan Dzindo, Mark Jackson, Nhung Luong (Laura), Trung Nguyen (Mark)
* FIRST VERSION        :    November 6th, 2020
* DESCRIPTION          :    The Project contains the needed files for Project 1 (Guessify).
*/

// Tested on iPhone 11 Pro Max
// Features:
//      - Difficulty (easy, medium, hard)
//      - Sound Effects (background, winning, losing)
//      - Dark/Light Mode

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // background music
    var backGroundPlayer = AVAudioPlayer();
    var soundPlayer = AVAudioPlayer()

    // labels
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var randomNumberLbl: UILabel!
    @IBOutlet weak var checkValueLbl: UILabel!

    // slider
    @IBOutlet weak var guessSlider: UISlider!

    // button references (used to disable / enable)
    @IBOutlet weak var tryBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!

    // segment control
    @IBOutlet weak var difficultyControl: UISegmentedControl!

    // variables
    var totalScore: Int = 0
    var generatedRandomNumber: Int = 0
    var difficulty = difficulties.easy
    var usersGuess: Int = 0

    // level modes
    enum difficulties: String {
        case easy
        case medium
        case hard
    }
    
    /*
    * FUNCTION     : playMusic
    * DESCRIPTION  : incharge of playing the selected music/song
    * PARAMETERS   : sound:     String
                     type:      String
                     playType:  Int
    * RETURNS      : N/A
    */
    func playMusic(sound: String, type: String, playType: Int) -> Void {
        if let path = Bundle.main.path(forResource: ("./Sound/" + sound), ofType: type) {
            do {
                backGroundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                backGroundPlayer.numberOfLoops = playType;
                backGroundPlayer.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    
    /*
    * FUNCTION     : playSound
    * DESCRIPTION  : incharge of playing the selected sound effect
    * PARAMETERS   : sound:     String
                     type:      String
                     playType:  Int
    * RETURNS      : N/A
    */
    func playSound(sound: String, type: String, playType: Int) -> Void {
        if let path = Bundle.main.path(forResource: ("./Sound/" + sound), ofType: type) {
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                soundPlayer.numberOfLoops = playType;
                soundPlayer.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // start background music
        playMusic(sound: "chillout", type: "mp3", playType: -1)

        // set default state
        scoreLbl.text = String(totalScore)
        tryBtn.isEnabled = true
        checkBtn.isEnabled = false
        guessSlider.isUserInteractionEnabled = false
        view.backgroundColor = .secondarySystemBackground

        switch traitCollection.userInterfaceStyle {
            case .dark:
                break
            case .light:
                break
            default:
                print("")
        }
    }

    /*
    * FUNCTION     : tryBtn
    * DESCRIPTION  : starts the game and generates the random number and set the
                     limits on the slider also set some objects to be interactable
    * PARAMETERS   : _ sender: UIButton
    * RETURNS      : N/A
    */
    @IBAction func tryBtn(_ sender: UIButton) {
        switch difficulty {
            case .easy:
                generatedRandomNumber = Int.random(in: 1...100)
                randomNumberLbl.text = String(generatedRandomNumber)
                guessSlider.minimumValue = 1
                guessSlider.maximumValue = 100
            case .medium:
                generatedRandomNumber = Int.random(in: 1...150)
                randomNumberLbl.text = String(generatedRandomNumber)
                guessSlider.minimumValue = 1
                guessSlider.maximumValue = 150
            case .hard:
                generatedRandomNumber = Int.random(in: 1...200)
                randomNumberLbl.text = String(generatedRandomNumber)
                guessSlider.minimumValue = 1
                guessSlider.maximumValue = 200
        }

        checkValueLbl.text = "???"                  //set the guess label back to "???"
        tryBtn.isEnabled = false                    //disable the try button
        checkBtn.isEnabled = true                   //enable the check button
        guessSlider.isUserInteractionEnabled = true //enable the slider
    }

    /*
    * FUNCTION     : checkBtn
    * DESCRIPTION  : compare how well the user guessed by generating a score and then showing a results popup
    * PARAMETERS   : _ sender: UIButton
    * RETURNS      : N/A
    */
    @IBAction func checkBtn(_ sender: UIButton) {
        //call the score function to determine how well the user did
        let score = calculateScore(generatedRandomNumber: generatedRandomNumber, usersGuess: usersGuess)
        //show the results popup
        showConclusionPopup(randomNumber: generatedRandomNumber, selectedNumber: usersGuess, points: score)
        checkValueLbl.text = String(usersGuess)         //show the user's guess in the label
        tryBtn.isEnabled = true                         //re-enable the try button
        checkBtn.isEnabled = false                      //disable the check button
        guessSlider.isUserInteractionEnabled = false    //disable the slider
    }

    /*
    * FUNCTION     : showConclusionPopup
    * DESCRIPTION  : show a popup with the results of the game
    * PARAMETERS   : randomNumber: Int
                     selectedNumber: Int
                     points: Int
    * RETURNS      : N/A
    */
    func showConclusionPopup(randomNumber: Int, selectedNumber: Int, points: Int) -> Void {
        //build the alert
        let popupController = UIAlertController(title: "Result", message: "The random number was \(randomNumber)\nYou guessed \(selectedNumber).\n This earned you \(points) points", preferredStyle: .alert)
        //create a confirm action
        //when this action is selected, close the popup
        let closeAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        //add the actions to the popup
        popupController.addAction(closeAction)
        //show the popup
        self.present(popupController, animated: true, completion: nil)
    }

    /*
    * FUNCTION     : resetBtn
    * DESCRIPTION  : reset all of the game objects and labels
    * PARAMETERS   : _ sender: UIButton
    * RETURNS      : N/A
    */
    @IBAction func resetBtn(_ sender: UIButton) {
        //set all of the game variable back to their default state
        totalScore = 0
        generatedRandomNumber = 0
        difficulty = difficulties.easy
        usersGuess = 0

        difficultyControl.selectedSegmentIndex = 0              //reset the selected segment to default
        tryBtn.isEnabled = true                                 //reenable the try button
        checkBtn.isEnabled = false                              //disable the check button
        guessSlider.isUserInteractionEnabled = false            //disable the slider
        scoreLbl.text = String(totalScore)                      //remove the score in the label
        randomNumberLbl.text = String(generatedRandomNumber)    //remove the randomly generated number from the label
        checkValueLbl.text = "???"                              //reset the guess to "???"
    }

    /*
    * FUNCTION     : sliderValueChanged
    * DESCRIPTION  : update the "userGuess" global when the slider value changes
    * PARAMETERS   : _ sender: UIButton
    * RETURNS      : N/A
    */
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        usersGuess = Int(sender.value)
        print("Users Guess via Slider -> \(usersGuess)")        // used to debug to allow us to check where we are within the slider to check if the popups are working
    }

    /*
    * FUNCTION     : difficultyControl
    * DESCRIPTION  : select the difficult based on which segment is selected
    * PARAMETERS   : _ sender: UISegmentedControl
    * RETURNS      : N/A
    */
    @IBAction func difficultyControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                difficulty = .easy
            case 1:
                difficulty = .medium
            case 2:
                difficulty = .hard
            default:
                break
        }
    }

    /*
    * FUNCTION     : calculateScore
    * DESCRIPTION  : calculate the score based on how far the guess was from the generated number
    * PARAMETERS   : generatedRandomNumber: Int
                     usersGuess: Int
    * RETURNS      : score: Int - the score that was generated global "totalScore" is updated "scoreLbl" has it's text changed
    */
    func calculateScore(generatedRandomNumber: Int, usersGuess: Int) -> Int {
        var score = 0;                                          //variable where we store the score before returning it
        var win = false                                         //variable where we store whether we sould play the win sound effect
        let within = abs(usersGuess - generatedRandomNumber)    // find out how close to the answer we are
        //if we are within 3 numbers, score 5
        if(within <= 3) {
            score = 5
            win = true
        //if we are within 10 numbers score 4
        } else if(within <= 10) {
            score = 4
        //if we are within 15 numbers score 3
        } else if(within <= 15) {
            score = 3
        //if we are within 25 numbers score 2
        } else if(within <= 25) {
            score = 2
        //if we are within 40 numbers score 1
        } else if (within <= 40) {
            score = 1
        //else score 0
        } else {
            score = 0
        }
        totalScore = totalScore + score                         //update the total score to be the old score plus the new score
        scoreLbl.text = String(totalScore)                      //update the score label
        if(win == true){
            playSound(sound: "applause2", type: "mp3", playType: 0) //play the win sound effect
        }else{
            playSound(sound: "game-lose", type: "mp3", playType: 1) //play the lose sound effect
        }
        return score
    }
}
