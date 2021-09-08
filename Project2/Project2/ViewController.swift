//
//  ViewController.swift
//  Project2
//
//  Created by 장선영 on 2021/09/04.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questions = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria","poland","russia","spain","uk","us"]
        
//        countries.append("estonia")
//        countries.append("france")
//        countries.append("germany")
//        countries.append("ireland")
//        countries.append("italy")
//        countries.append("monaco")
//        countries.append("nigeria")
//        countries.append("poland")
//        countries.append("russia")
//        countries.append("spain")
//        countries.append("uk")
//        countries.append("us")
        
//        askQuestion(action: nil)
        askQuestion()
        
        
        [button1,button2,button3].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(showScore))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + "  score: \(score)"
        
        if questions >= 10 {
            let alert = UIAlertController(title: "", message: "Your final score is \(score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "done", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            questions += 1
        }
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            message = "Your score is \(score)"
            score += 1
        } else {
            title = "Wrong"
            message = "Thats's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style:.default, handler: askQuestion))
        present(ac, animated: true, completion: nil)
    }
    
    
    @objc func showScore() {
        let vc = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(vc, animated: true, completion: nil)
    }
}

