//
//  ViewController.swift
//  VocabularyFlashcardsIphone
//
//  Created by Evan Sitzes on 9/29/16.
//  Copyright © 2016 Evan Sitzes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func koreanLanguage(_ button: UIButton) {
        showLevelSelection(buttonText: button.titleLabel!.text!)
    }

    @IBAction func japaneseLanguage(_ button: UIButton) {
        showLevelSelection(buttonText: button.titleLabel!.text!)
    }

    @IBAction func chineseLanguage(_ button: UIButton) {
        showLevelSelection(buttonText: button.titleLabel!.text!)
    }
    
    func showLevelSelection(buttonText: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LevelSelectionViewController = storyboard.instantiateViewController(withIdentifier: "selectionView") as! LevelSelectionViewController
        vc.language = buttonText
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
}

