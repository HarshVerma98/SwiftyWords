//
//  ViewController.swift
//  Project8 Swifty Words
//
//  Created by Harsh Verma on 09/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    var clueLabel: UILabel!
    var answerLabel: UILabel!
    var curentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButton = [UIButton]()
    var activatedButton = [UIButton]()
    var soluions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    let maxLevel = 2
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        scoreLabel = UILabel()
        scoreLabel.tintColor = .label
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        
        clueLabel = UILabel()
        clueLabel.translatesAutoresizingMaskIntoConstraints = false
        clueLabel.font = UIFont.systemFont(ofSize: 26)
        clueLabel.tintColor = .label
        clueLabel.text = "Clues"
        clueLabel.numberOfLines = 0
        clueLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(clueLabel)
        
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 26)
        answerLabel.text = "Answers"
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .right
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        curentAnswer = UITextField()
        curentAnswer.translatesAutoresizingMaskIntoConstraints = false
        curentAnswer.placeholder = "Tap Letters to Guess"
        curentAnswer.textAlignment = .center
        curentAnswer.font = UIFont.systemFont(ofSize: 44)
        curentAnswer.isUserInteractionEnabled = false
        view.addSubview(curentAnswer)
        
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        //Challenge 1 Here
        buttonView.layer.borderWidth = 0.5
        buttonView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonView)
        
        
        NSLayoutConstraint.activate([scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor), scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0), clueLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor), clueLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100), clueLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100), answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor), answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100), answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100), answerLabel.heightAnchor.constraint(equalTo: clueLabel.heightAnchor), curentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor), curentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5), curentAnswer.topAnchor.constraint(equalTo: clueLabel.bottomAnchor, constant: 20), submit.topAnchor.constraint(equalTo: curentAnswer.bottomAnchor), submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100), submit.heightAnchor.constraint(equalToConstant: 44), clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100), clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor), clear.heightAnchor.constraint(equalToConstant: 44), buttonView.widthAnchor.constraint(equalToConstant: 750), buttonView.heightAnchor.constraint(equalToConstant: 320), buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor), buttonView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20), buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)])
        
        let width = 150
        let height = 80
        
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterB = UIButton(type: .system)
                letterB.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterB.setTitle("ABCDEFGH", for: .normal)
                
                
                // Frame calculate using row and col
                let frame = CGRect(x: col*width, y: row*height, width: width, height: height)
                letterB.frame = frame
                buttonView.addSubview(letterB)
                letterButton.append(letterB)
                letterB.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevels()
        // Do any additional setup after loading the view.
    }
    
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let bTitle = sender.titleLabel?.text else {
            return
        }
        curentAnswer.text = curentAnswer.text?.appending(bTitle)
        activatedButton.append(sender)
        sender.isHidden = true
    }
    
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let atext = curentAnswer.text else {
            return
        }
        
        // For avoiding point removal for empty answers
        if atext.isEmpty {
            return
        }
        
        if let solPos = soluions.firstIndex(of: atext) {
            activatedButton.removeAll()
            
            var split = answerLabel.text?.components(separatedBy: "\n")
            split?[solPos] = atext
            answerLabel.text = split?.joined(separator: "\n")
            
            curentAnswer.text = ""
            score += 1
            //            if score % 7 == 0 {
            //                let alert = UIAlertController(title: "Well Done!", message: "Ready for next Level?", preferredStyle: .alert)
            //                alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: nil))
            //                present(alert, animated: true)
            //            }
            
            //Challenge 3
            
            if AllButonPres() {
                let alert = UIAlertController(title: "Well Done!", message: "Ready for next Level?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: levelUP))
                present(alert, animated: true)
            }
            
            
            
            
        } //Challenge 2
        else {
            let alert = UIAlertController(title: "Incorrect!", message: "\"\(atext)\" does not match answer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            
            //Challenge 3
            score -= 1
        }
    }
    
    
    
    @objc func clearTapped(_ sender: UIButton) {
        curentAnswer.text = ""
        
        for b in activatedButton {
            b.isHidden = false
        }
        activatedButton.removeAll()
    }
    
    
    func loadLevels() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        
        if let filePath = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let contents = try? String(contentsOf: filePath) {
                var line = contents.components(separatedBy: "\n")
                line.shuffle()
                
                
                for(index, line) in line.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWd = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWd.count) letters\n"
                    soluions.append(solutionWd)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                    
                }
            }
        }
        
        clueLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButton.count {
            for i in 0..<letterButton.count {
                letterButton[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    
    //Challenge 3
    
    func AllButonPres() -> Bool {
        for b in letterButton {
            if b.isHidden == false {
                return false
            }
        }
        return true
    }
    
    
    
    func levelUP(action: UIAlertAction) {
        level += 1
        soluions.removeAll(keepingCapacity: true)
        loadLevels()
        
        for b in letterButton {
            b.isHidden = false
        }
    }
    
}

