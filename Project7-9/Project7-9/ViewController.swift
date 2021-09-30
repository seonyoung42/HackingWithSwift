//
//  ViewController.swift
//  Project7-9
//
//  Created by 장선영 on 2021/09/30.
//

import UIKit

class ViewController: UIViewController {
    var letterLabel: UILabel!
    var buttonView : UIView!
    
    var wordArray = [String]()
    var answerWord = ""
   
    var letterArray = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 단어 불러오기
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                wordArray = startWords.components(separatedBy: "\n")
            }
        }
        
        if wordArray.isEmpty {
            wordArray = ["Empty"]
        }
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(placeNewWord))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "submit", style: .plain, target: self, action: #selector(submitWord))
        
        letterLabel = UILabel(frame: CGRect(x: 50, y: 100, width: 200, height: 50))
        letterLabel.backgroundColor = .lightGray
        letterLabel.textColor = .blue
        letterLabel.textAlignment = .center
        letterLabel.text = "Lets' start HangMan!"
        view.addSubview(letterLabel)
        
        buttonView.addConstraint()
    }
    
    @objc func placeNewWord() {
        wordArray.shuffle()
        letterLabel.text?.removeAll()
        answerWord = wordArray[0]
        title = answerWord
        for _ in answerWord {
            letterLabel.text?.append("?")
        }
        
    }
    
    @objc func submitWord() {
        
        let ac = UIAlertController(title: "", message: "Insert a Alphabet", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        
        let checkLetter = UIAlertAction(title: "OK", style: .default) { _ in
            guard let enteredLetter = ac.textFields?[0].text?.first else { return }
            self.checkWord(enteredLetter)
        }
        
        ac.addAction(checkLetter)
        ac.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    func checkWord(_ letter: Character) {
        
        letterLabel.text = ""
        
        if answerWord.contains(letter) {
            
            letterArray.append(letter)
            
            for char in answerWord {
                if char == letter {
                    letterLabel.text?.append(char)
                } else {
                    letterLabel.text?.append("?")
                }
            }
        }
    }
}

