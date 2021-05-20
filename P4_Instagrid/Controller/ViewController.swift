//
//  ViewController.swift
//  P4_Instagrid
//
//  Created by Gaël HENROT on 03/05/2021.
//
/*
 L'application permet de créer des petits montages carrés de 3 ou 4 photos.
 1. L'utilisateur choisit une des trois dispositions
 1.1 L'utilisateur appuie sur un des trois ou quatres boutons:
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
 3.4 La grille revient à sa place d'origine
 */

import UIKit

class ViewController: UIViewController  {
    
    //=======================================
    //MARK: Variables declaration
    //=======================================
    
    //    Variable which contains the orientation of the device
    var isPortrait: Bool?
    
    //    Variable which store the current plus buttton tapped by the user
    var currentButton: UIButton?
    
    //=======================================
    //MARK: Outlets declaration
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
    
    //    Declaration of the swipe label
    @IBOutlet weak var swipeLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePattern(pattern: .pattern21) // Define the default view
        
        defineOrientation()
        defineSwipeLabel()
        
        //        Initialization of the share gesture to moving the grid
        let shareGesture = UIPanGestureRecognizer(target: self, action: #selector(dragTheGrid(_:)))
        grid.addGestureRecognizer(shareGesture)
        
        //        let shareGesture = UISwipeGestureRecognizer(target: self, action: #selector(dragTheGrid(_:)))
        //                Think about changing it according to orientation
        //                shareGesture.direction = .up
        //        grid.addGestureRecognizer(shareGesture)
        
    }
    
    /// This method define the orientation of the device thanks to size classes (modify the isPortrait value)
    func defineOrientation() {
        if traitCollection.horizontalSizeClass == .compact {
            isPortrait = true
        } else {
            isPortrait = false
        }
    }
    
    /// This method change the swipe label text thanks to actual size class.
    func defineSwipeLabel() {
        if traitCollection.horizontalSizeClass == .compact {
            swipeLabel?.text = "Swipe up to share"
        } else {
            swipeLabel?.text = "Swipe left to share"
        }
    }
    
    //=======================================
    //MARK: Pattern selector
    //=======================================
    
    //    Enumarate the pattern cases of the grid
    enum PatternType {
        case pattern12, pattern21, pattern22
    }
    /// This method change the pattern of the middle view by hiding or not the buttons in the grid.
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
    
    /// This method allows the user to choose a photo in his library or to take a photo with his camera (by creating an UIImagePickerController and an UIAlertController).
    /// If the camera is not available, the function open directly the library.
    func chooseAPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
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
            
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //Declaration of plus buttons actions
    @IBAction func upLeftChooseAPhoto(_ sender: UIButton) {
        currentButton = sender
        chooseAPhoto()
    }
    
    @IBAction func upRightChooseAPhoto(_ sender: UIButton) {
        currentButton = sender
        chooseAPhoto()
    }
    
    @IBAction func downLeftChooseAPhoto(_ sender: UIButton) {
        currentButton = sender
        chooseAPhoto()
    }
    
    @IBAction func downRightChooseAPhoto(_ sender: UIButton) {
        currentButton = sender
        chooseAPhoto()
    }
    
    
    //=======================================
    //MARK: Share the grid
    //=======================================
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        defineOrientation()
        defineSwipeLabel()
    }
    
    @objc func dragTheGrid(_ sender: UIPanGestureRecognizer) {
        // think to add a condition (only use .up direction if the device is portrait and .left if the device is landscape)
        switch sender.state {
        case .began, .changed:
            moveTheGrid(sender)
        case .ended, .cancelled:
            slideAndShareTheGrid(sender)
        default:
            break
        }
    }
    /// This method allows the user to move the grid (in only one direction).
    func moveTheGrid(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: grid)
        if isPortrait == true {
            grid.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else {
            grid.transform = CGAffineTransform(translationX: translation.x, y: 0)
        }
    }
    
    /// This method move the grid out of the screen in the non visible area and call the shareTheGrid method.
    func slideAndShareTheGrid(_ gesture: UIPanGestureRecognizer) {
        
        var screenSize: CGFloat
        var gridSize: CGFloat
        let translation = gesture.translation(in: grid)
        var translationTransform: CGAffineTransform
        var translationTransformation: CGAffineTransform
        let translationDirection: CGFloat
        
        if isPortrait == true {
            screenSize = UIScreen.main.bounds.height
            gridSize = grid.bounds.height
            translationDirection = translation.y
            translationTransform = CGAffineTransform(translationX: 0, y: -screenSize)
        } else {
            screenSize = UIScreen.main.bounds.width
            gridSize = grid.bounds.width
            translationDirection = translation.x
            translationTransform = CGAffineTransform(translationX: -screenSize, y: 0)
        }
        
        if translationDirection < -gridSize/5 {
            translationTransformation = translationTransform
            shareTheGrid()
        } else {
            translationTransformation = .identity
        }
        UIView.animate(withDuration: 0.4, animations: {self.grid.transform = translationTransformation}, completion: nil)
    }
    
    /// This method returns the grid to its original position.
    func moveBackTheGrid() {
        let translationTransform: CGAffineTransform = .identity
        UIView.animate(withDuration: 0.4, animations: {self.grid.transform = translationTransform}, completion: nil)
    }
    
    /// This method open an Activity Controller and present the possible actions to realize with the image of the grid.
    /// It call the moveBackTheGrid method when the user has done is choice.
    func shareTheGrid() {
        let activityViewController = UIActivityViewController(activityItems: [convertTheGridToImage()], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
                                                                Bool, arrayReturnedItems: [Any]?, error: Error?) in
            self.moveBackTheGrid()
        }
    }
    
    /// This method convert the grid in to a UIImage and return it.
    func convertTheGridToImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: grid.bounds.size)
        let image = renderer.image { ctx in
            grid.drawHierarchy(in: grid.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
}
//MARK: UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    
    /// This method wait the user. When the user has chosen an image, the image is set and adjust in the current plus button.
    /// The user can only choose a image (guarantee by the UIImagePickerController).
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        currentButton?.setImage(image, for: .normal) // Replace the previous image (plus or previously choosed image) in the current plus button
        currentButton?.imageView!.contentMode = .scaleAspectFill // Change the content mode of the current button to
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}
