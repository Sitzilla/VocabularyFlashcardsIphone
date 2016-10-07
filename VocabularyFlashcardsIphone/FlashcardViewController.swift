//
//  FlashcardViewController.swift
//  VocabularyFlashcardsIphone
//
//  Created by Evan Sitzes on 9/29/16.
//  Copyright © 2016 Evan Sitzes. All rights reserved.
//

import UIKit
import Foundation

class FlashcardViewController: UIViewController {

    var languageCategory: String = ""
    var words: NSMutableArray = []
    var currentWordIndex: Int = 0
    var categoriesEndpoint = "https://vocabularyterms.herokuapp.com/korean?category={category}"
    var toggleWords = false
    var dataFile: String = ""
    
    @IBOutlet weak var remainingWords: UILabel!
    @IBOutlet weak var englishWord: UILabel!
    @IBOutlet weak var foreignWord: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataFile = "LanguageInSitzesFlashcardData" + languageCategory + ".txt" //this is the file. we will write to and read from it
        
        // Format navigation bar
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FlashcardViewController.goBack))
        navigationItem.leftBarButtonItem = backButton

        let toggleButton = UIBarButtonItem(title: "Toggle", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FlashcardViewController.toggleLanguage))
        navigationItem.rightBarButtonItem = toggleButton
        
        print("Passed category: ", languageCategory)
        
//        if (words.count == 0) {
            dataRequest()
//        }
        
//        writeToFile()
//        readFromFile()
        
    }
    
    @IBAction func resetWords(_ sender: AnyObject) {
        dataRequest()
    }
    
    func readFromFile() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(dataFile)
            
            //reading
            do {
                let text2: String = try String(contentsOf: path, encoding: String.Encoding.utf8)
                print("Read from file: ", text2)
                
//                self.words = text2 as! NSMutableArray
            }
            catch {/* error handling here */}
        }
        
    }
    
    func writeToFile() {
        
        let cocoaArray : NSArray = words
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(dataFile)
            
            //writing
            do {
                try cocoaArray.write(to: path, atomically: false)
            }
            catch {/* error handling here */}
        }
        
    }

    func toggleLanguage(){
        if (toggleWords) {
            toggleWords = false
        } else {
            toggleWords = true
        }
    }
    
    func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    func buildFlashcards() {
        print("Words remaining: ", words.count)
        remainingWords.text = String(words.count) + " Remaining Words"
        
        // TODO disable buttons if nothing to press
        if (words.count > 0) {
            setText(newWordIndex: getRandomWordIndex())
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.foreignWord.isHidden = true
            })
        }
    }
    
    func setText(newWordIndex: Int) {
        let currentWord = words[newWordIndex] as AnyObject
        currentWordIndex = newWordIndex
        
        if (toggleWords) {
            englishWord.text = currentWord["englishWord"] as? String
            foreignWord.text = currentWord["foreignWord"] as? String
            return
        }
        
        englishWord.text = currentWord["foreignWord"] as? String
        foreignWord.text = currentWord["englishWord"] as? String
    }
    
    func getRandomWordIndex() -> Int {
        return Int(arc4random_uniform(UInt32(words.count)))
    }
    
    @IBAction func showAnswer(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.foreignWord.isHidden = false
        })
    }
    
    @IBAction func nextWord(_ sender: AnyObject) {
        buildFlashcards()
    }
    
    @IBAction func deleteWord(_ sender: AnyObject) {
        words.removeObject(at: currentWordIndex)
        self.writeToFile()
        buildFlashcards()
    }
    
    // TODO combine api request functions
    @IBAction func increaseWordKnowledgeCount(_ sender: AnyObject) {
        let currentWord = words[currentWordIndex] as AnyObject
        let currentIdAsInt = currentWord["id"] as! Int
        let currentIdAsString = "\(currentIdAsInt)"

        print("ID is:", currentIdAsString)
        let increaseEndpoint = "https://vocabularyterms.herokuapp.com/korean/" + currentIdAsString + "/increase"
        print(increaseEndpoint)
    
        let session = URLSession.shared
        let url: String = increaseEndpoint
        let categoriesRequestUrl = URL(string: url)
        var request = URLRequest(url:categoriesRequestUrl!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let client = session.dataTask(with: request as URLRequest) {
            data, response, error in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                print("ERROR OCCURED WITH API REQUEST")
                print(networkError)
                
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                do {
                    DispatchQueue.main.async {
                        self.deleteWord("hello world" as AnyObject)
                    }
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("CRAPPY RANDOM JSON ERROR")
                    print(jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        client.resume()
    }
    
    func dataRequest() {
        let session = URLSession.shared
        let url: String = "http://vocabularyterms.herokuapp.com/korean?category=" + languageCategory
        let categoriesRequestUrl = URL(string: url)
        var request = URLRequest(url:categoriesRequestUrl!)
        request.httpMethod = "GET"
        
        // The data task retrieves the data.
        let client = session.dataTask(with: request as URLRequest) {
            data, response, error in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                print("ERROR OCCURED WITH API REQUEST")
                print(networkError)
                
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let response = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! [String: AnyObject]
                    
                    self.words = response["words"] as! NSMutableArray
                    self.writeToFile()
                    DispatchQueue.main.async {
                        self.buildFlashcards()
                    }
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("CRAPPY RANDOM JSON ERROR")
                    print(jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        client.resume()
        
    }

}
