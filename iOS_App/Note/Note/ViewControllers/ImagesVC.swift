//
//  ImagesVC.swift
//  Note
//
//  Created by Mausam on 7/11/17.
//  Copyright © 2017 Mausam. All rights reserved.
//

import UIKit

class ImagesVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    let imagePicker = UIImagePickerController()
    var isNewNote:Bool!
    var imageUrlArray:[URL] = []
    var imagesFolderPath:URL?
    let reuseIdentifier = "cell"
    var selectedImageArrayIndex:Int?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        self.navigationItem.rightBarButtonItem = createAddImageBarButtonItem()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadImages()
    }
    
    func loadImages() {
        self.title = "Images"
        if isNewNote{
            imageUrlArray = loadListOfFilesFromFolderPath(path: appDelegate.tempNoteImagePath)
        }
        else{
            imageUrlArray = loadListOfFilesFromFolderPath(path: appDelegate.noteDataPath.appendingPathComponent((appDelegate.currentNote?.id)!))
        }
        collectionView.reloadData()
    }
    
    func createAddImageBarButtonItem() -> UIBarButtonItem {
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.clickOnAddImageBarButtonItem))
        return leftBarButton
    }
    
    //MARK: - UICollectionview methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ImageCollectionCell
        
        DispatchQueue.global().async {[weak weakSelf = self] in
            let image = UIImage(contentsOfFile: (weakSelf?.imageUrlArray[indexPath.row].path)!)
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageArrayIndex = indexPath.row
        imageClickAlertOptions()
    }
    
    
    
    func clickOnAddImageBarButtonItem(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - ImagePickerView Deletegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageCount = Int((appDelegate.currentNote?.imageNameCount)!)
        appDelegate.currentNote?.imageNameCount = String(imageCount!+1)
        
        if  let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData: NSData = UIImageJPEGRepresentation(pickedImage, 0.1)! as NSData
            if isNewNote{
                if copyDataToTheFolder(data: imageData as Data, fileName: (appDelegate.currentNote?.imageNameCount)! + ".jpg", destinationPath: appDelegate.tempNoteImagePath){
                    imageUrlArray.append(appDelegate.tempNoteImagePath.appendingPathComponent((appDelegate.currentNote?.imageNameCount)!))
                }
            }
            else{
                if copyDataToTheFolder(data: imageData as Data, fileName: (appDelegate.currentNote?.imageNameCount)! + ".jpg", destinationPath: imagesFolderPath!){
                    imageUrlArray.append((imagesFolderPath?.appendingPathComponent((appDelegate.currentNote?.imageNameCount)!))!)
                }
            }
            collectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
    
    
    //MARK: - ImageClickAlert
    
    func imageClickAlertOptions() {
        let alert = UIAlertController(title: "Options For Selected Image", message:"" , preferredStyle: .alert)
        weak var weakSelf = self
        
        let previewAction = UIAlertAction(title: "Preview Image", style: .default) { (alert) in
            let ql = QLPreview()
            ql.previewUrl = weakSelf?.imageUrlArray[(weakSelf?.selectedImageArrayIndex!)!]
            print("opening file : \(String(describing: ql.previewUrl))")
            weakSelf?.present(ql, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Delete Image", style: .default) { (alert) in
            weakSelf?.deleteSelectedImage()
        }
        
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel) { (alert) in
        }
        alert.addAction(previewAction)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteSelectedImage() {
        removeFileOrFolderFromPath(path: imageUrlArray[selectedImageArrayIndex!])
        imageUrlArray.remove(at: selectedImageArrayIndex!)
        collectionView.reloadData()
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
