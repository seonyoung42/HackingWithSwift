//
//  ViewController.swift
//  Project8
//
//  Created by 장선영 on 2021/09/26.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scorelabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButton = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scorelabel.text = "Score: \(score)"
        }
    }
    var realScore = 0
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        //more code to come!
        scorelabel = UILabel()
        scorelabel.textAlignment = .right
        scorelabel.text = "Score: 0"
        
        cluesLabel = UILabel()
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        answerLabel = UILabel()
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.textAlignment = .right
        answerLabel.text = "ANSWERS"
        answerLabel.numberOfLines = 0
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer = UITextField()
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 24)
        currentAnswer.isUserInteractionEnabled = true
        
        [scorelabel,cluesLabel,answerLabel,currentAnswer].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0!)
        }
        
        
        
        let submit = UIButton(type: .system)
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTepped(_:)), for: .touchUpInside)
        
        let clear = UIButton(type: .system)
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTepped(_:)), for: .touchUpInside)
        
        let buttonsView = UIView()
        buttonsView.layer.borderWidth = 5
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        
        [submit,clear,buttonsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        
        
        NSLayoutConstraint.activate([
            scorelabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scorelabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scorelabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            answerLabel.topAnchor.constraint(equalTo: scorelabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4,constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor,multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTepped(_:)), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.loadLevel()
        }
//        loadLevel()
    }


    @objc func letterTepped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButton.append(sender)
        
        UIView.animate(withDuration: 0.75) {
            sender.alpha = 0.0
        }
//        sender.isHidden = true
    }
    
    @objc func submitTepped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButton.removeAll()
            
            var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answerLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            realScore += 1
            
            if realScore % 7 == 0 {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for the next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's goal", style: .default, handler: levelUp))
                present(ac, animated: true, completion: nil)
            }
        } else {
            let ac = UIAlertController(title: "Wrong", message: "Try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.activatedButton.forEach {
                    $0.isHidden = false
                }
                self.activatedButton.removeAll()
                self.currentAnswer.text = ""
            }))
            
            present(ac, animated: true, completion: nil)
            score -= 1
      
        }
    }
    
    
    @objc func clearTepped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        UIView.animate(withDuration: 1) {
            for button in self.letterButtons {
                button.alpha = 1.0
            }
        }
        
//        for button in activatedButton {
//            button.isHidden = false
//        }
        
        activatedButton.removeAll()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionStrin = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    clueString += "\(index+1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionStrin += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.answerLabel.text = solutionStrin.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self?.letterButtons.shuffle()
            if let letterbuttons = self?.letterButtons {
                if letterbuttons.count == letterBits.count {
                    for i in 0..<letterbuttons.count {
                        self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                    }
                }
            }
            
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        UIView.animate(withDuration: 1) {
            for button in self.letterButtons {
                button.alpha = 1.0
            }
        }
        
//        for button in letterButtons {
//            button.isHidden = false
//        }
    }
}

