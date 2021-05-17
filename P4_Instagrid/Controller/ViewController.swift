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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //=======================================
    //MARK: Outlet buttons declaration
    //=======================================
    
//    Declaration of pattern selector buttons
    @IBOutlet weak var Pattern12Button: UIButton?
    @IBOutlet weak var Pattern21Button: UIButton?
    @IBOutlet weak var Pattern22Button: UIButton?
    
//    Declaration of image selector buttons
    @IBOutlet weak var upLeftButton: UIButton?
    @IBOutlet weak var upRightButton: UIButton?
    @IBOutlet weak var downLeftButton: UIButton?
    @IBOutlet weak var downRightButton: UIButton?
    
//    Declaration of the grid
    @IBOutlet weak var grid: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        changePattern(pattern: .pattern21) // Define the default view
        
//        Initialization of the share gesture to moving the grid
        let shareGesture = UIPanGestureRecognizer(target: self, action: #selector(dragTheGrid(_:)))
        grid.addGestureRecognizer(shareGesture)

//        let shareGesture = UISwipeGestureRecognizer(target: self, action: #selector(dragTheGrid(_:)))
//                Think about changing it according to orientation
//                shareGesture.direction = .up
//        grid.addGestureRecognizer(shareGesture)
        
    }
    
    //=======================================
    //MARK: Pattern selector
    //=======================================
    
//    Enumarate the pattern cases of the grid
    enum PatternType {
        case pattern12, pattern21, pattern22
    }
    /// This function change the pattern of the middle view by hidden or not the buttons in the grid
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
    
    //=======================================
    //MARK: Choose a photo
    //=======================================
    
    var imageChoosed : UIImage?
    /*enum LocationType {
        case upLeft, upRight, downLeft, downRight
    }*/
    
    func chooseAPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            
            let chooseAPhotoActionSheet = UIAlertController(title: "Photo Source", message: "Choose a source of photo", preferredStyle: .actionSheet)
            
            chooseAPhotoActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            chooseAPhotoActionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            chooseAPhotoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(chooseAPhotoActionSheet, animated: true, completion: nil)
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    //        upLeftButton?.setImage(image, for: .normal)
            switch locationType {
            case LocationType.upLeft:
                upLeftButton?.setImage(image, for: .normal)
            case LocationType.upRight:
                upRightButton?.setImage(image, for: .normal)
            case LocationType.downLeft:
                downLeftButton?.setImage(image, for: .normal)
            case LocationType.downRight:
                downRightButton?.setImage(image, for: .normal)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }*/
        
        
    }
    
    var currentButton: UIButton?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        upLeftButton?.setImage(image, for: .normal)
        imageChoosed = image
        currentButton?.setImage(imageChoosed, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Declaration of plus buttons actions
    @IBAction func upLeftChooseAPhoto(_ sender: UIButton) {
        currentButton = sender
        chooseAPhoto()
    }

    @IBAction func upRightChooseAPhoto(_ sender: UIButton) {
        chooseAPhoto()
        sender.setImage(imageChoosed, for: .normal)
    }
    
    @IBAction func downLeftChooseAPhoto(_ sender: UIButton) {
        chooseAPhoto()
        sender.setImage(imageChoosed, for: .normal)
    }
    
    @IBAction func downRightChooseAPhoto(_ sender: UIButton) {
        chooseAPhoto()
        sender.setImage(imageChoosed, for: .normal)
    }
    
    
    //=======================================
    //MARK: Share the grid
    //=======================================
    
    var isLandscape: Bool?
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
        case (.compact, .compact):
            isLandscape = true
        case (.regular, .compact):
            isLandscape = true
        case (.compact, .regular):
            isLandscape = false
        default: break
        }

    }
    
    @objc func dragTheGrid(_ sender: UIPanGestureRecognizer) {
        // think to add a condition (only use .up direction if the device is portrait and .left if the device is landscape)
        switch sender.state {
        case .began, .changed:
            moveTheGrid(gesture: sender)
        case .ended, .cancelled:
            slideAndHideTheGrid(gesture: sender)
            shareTheGrid()
//            moveBackTheGrid()
        default:
            break
        }
    }
    /// This function allows the user to move up and down the grid.
    private func moveTheGrid(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: grid)
        if isLandscape == false {
            grid.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else {
            grid.transform = CGAffineTransform(translationX: translation.x, y: 0)
        }
    }
    
    ///This function move the grid out of the screen in the upper non visible area.
    private func slideAndHideTheGrid(gesture: UIPanGestureRecognizer) {
        
        var screenSize: CGFloat
//        var gridSize: CGFloat
//        let translation = gesture.translation(in: grid)
        var translationTransform: CGAffineTransform
//        let translationDirection: CGFloat
        
        if isLandscape == false {
            screenSize = UIScreen.main.bounds.height
//            gridSize = grid.bounds.height
//            translationDirection = translation.y
            translationTransform = CGAffineTransform(translationX: 0, y: -screenSize)
        } else {
            screenSize = UIScreen.main.bounds.width
//            gridSize = grid.bounds.width
//            translationDirection = translation.x
            translationTransform = CGAffineTransform(translationX: -screenSize, y: 0)
        }

        
        
        /*if translationDirection < -gridSize/5 {
            translationTransform = CGAffineTransform(translationX: 0, y: -screenSize)
        } else {
            translationTransform = .identity
        }*/
        UIView.animate(withDuration: 0.4, animations: {self.grid.transform = translationTransform}, completion: nil)
    }
    
    /// This function returns the grid to its original position.
    private func moveBackTheGrid() {
        let translationTransform: CGAffineTransform = .identity
        UIView.animate(withDuration: 0.4, animations: {self.grid.transform = translationTransform}, completion: nil)
    }
    
    /// This function open an Activity Controller and present the possible actions to realize  with the image of the grid.
    func shareTheGrid() {
        /*guard let image = imageShared.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }*/

        let activityViewController = UIActivityViewController(activityItems: [convertTheGridToImage()], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    /// This function convert the grid in to a UIImage and return it.
    func convertTheGridToImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: grid.bounds.size)
        let image = renderer.image { ctx in
            grid.drawHierarchy(in: grid.bounds, afterScreenUpdates: true)
        }
        return image
    }

}
