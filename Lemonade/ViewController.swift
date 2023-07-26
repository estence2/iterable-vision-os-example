//
//  ViewController.swift
//  Lemonade
//
//  Created by Ellen Stence on 11/16/22.
//

import SwiftUI
import UIKit
import IterableSDK
import Foundation

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    func setEmail() {
        IterableAPI.email = Tokens.email
    }
    
    let answers = ["Yes, definitely", "It is certain", "Without a doubt", "Yes", "Most likely", "Sure, why not?", "Same", "Tell me more", "Out to lunch", "Reply hazy, try again", "Ask again later", "Iterable can!", "42", "TMI", "Very doubtful", "Don't count on it", "My reply is no", "Absolutely not"]
    
    func generateAnswer() -> String {
        let randomIndex = Int.random(in: 0..<answers.count)

        answerLabel.text = answers[randomIndex]
        return answerLabel.text!
    }
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var shakeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func shakeButtonTapped(_ sender: Any) {
        //generateAnswer()
        setEmail()
        let dataField: [String: Any] = [
            "testMobileField":generateAnswer()]
        IterableAPI.updateUser(dataField,
                               mergeNestedObjects: false,
                               onSuccess: myUserUpdateSuccessHandler,
                               onFailure: myUserUpdateFailureHandler)
        IterableAPI.track(
            event: "shakePhone",
            dataFields: dataField
        )
    }
    func myUserUpdateSuccessHandler(data: [AnyHashable: Any]?) -> () {
        print("Successfully sent user update request to Iterable")
    }

    func myUserUpdateFailureHandler(reason: String?, data: Data?) -> () {
        print("Failure sending user update request to Iterable")
    }
    /* comment out non-compatible gestures like motion for compatibility with vision OS
     override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        generateAnswer()
    }
     */
    
    @IBAction func allDone(_ sender: Any) {
        let dataField: [String: Any] = [
            "testMobileField":generateAnswer()]
        IterableAPI.track(
            event: "allDone",
            dataFields: dataField
        )
        
    }
}

