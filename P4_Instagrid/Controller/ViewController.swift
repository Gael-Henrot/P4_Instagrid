//
//  ViewController.swift
//  P4_Instagrid
//
//  Created by Gaël HENROT on 03/05/2021.
//
/*
 L'application permet de créer des petits montages carrés de 3 ou 4 photods.
 1. L'utilisateur choisit une des trois dispositions
    1.1 L'utlisateur appuie sur un des trois boutons:
        a. La coche de l'ancienne sélection est cachée
        b. La coche de la nouvelle sélection est affichée.
        c. La grille centrale change pour correspondre au choix de l'utilisateur
 2. L'utilisateur choisit 3 ou 4 photos
    2.1 L'utilisateur appuie sur un plus
    2.2 L'utilisateur choisit une photo
 3. L'utilisateur partage sa création
    3.1 L'utilisateur glisse la grille vers le haut ou la gauche
    3.2 La vue de partage apparait
    3.3 L'utilisateur choisit son moyen de partage
 */

import UIKit

class ViewController: UIViewController {
    
//    Declaration of pattern selector buttons
    @IBOutlet weak var Pattern12Button: UIButton?
    @IBOutlet weak var Pattern21Button: UIButton?
    @IBOutlet weak var Pattern22Button: UIButton?
    
//    Declaration of image selector buttons
    @IBOutlet weak var upLeftButton: UIButton?
    @IBOutlet weak var upRightButton: UIButton?
    @IBOutlet weak var downLeftButton: UIButton?
    @IBOutlet weak var downRightButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        changePattern(pattern: .pattern21)
        
//        firstLayoutButton?.setTitle("toto", for: .normal)
        
    }
    
   /* @IBAction func imageButtonSelected(_ sender: UIButton) {
        if sender == firstLayoutButton {
            // meme bouton
        } else {
            // Pas meme bouton
        }
    }*/
    enum PatternType {
        case pattern12, pattern21, pattern22
    }
    
    func changePattern(pattern: PatternType) {
        
//        upLeftButton?.isHidden = false
        upRightButton?.isHidden = false
//        downLeftButton?.isHidden = false
        downRightButton?.isHidden = false
        Pattern12Button?.isSelected = false
        Pattern21Button?.isSelected = false
        Pattern22Button?.isSelected = false
        
        switch pattern {
        
        case .pattern12:
            upRightButton?.isHidden = true
            Pattern12Button?.isSelected = true
        
        case .pattern21:
            downRightButton?.isHidden = true
            Pattern21Button?.isSelected = true
        
        case .pattern22:
            Pattern22Button?.isSelected = true
        }
    }
    
    @IBAction func didTapPattern12() {
        changePattern(pattern: .pattern12)
    }
    
    @IBAction func didTapPattern21() {
        changePattern(pattern: .pattern21)
        
    }
    
    @IBAction func didTapPattern22() {
        changePattern(pattern: .pattern22)
    }
    

}
