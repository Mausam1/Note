//
//  NewNote.swift
//  Note
//
//  Created by Mausam on 7/10/17.
//  Copyright © 2017 Mausam. All rights reserved.
//

import UIKit


class NewNoteVC: UIViewController,UITextFieldDelegate {
    
    var isNewNote:Bool!
    var noteId:String?
    var noteArrayIndex:Int?
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtVData: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.delegate = self
        txtTitle.becomeFirstResponder()
        if !isNewNote {
            self.navigationItem.rightBarButtonItem = createUpdateBarButtonItem()
            loadExistingNote()
        }
        else{
            appDelegate.currentNote = Note()
            appDelegate.currentNote?.imageNameCount = String(0)
            self.navigationItem.rightBarButtonItem = createSaveBarButtonItem()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        txtTitle.becomeFirstResponder()
    }
    
    
    func createSaveBarButtonItem() -> UIBarButtonItem {
        let leftBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveButtonTapped))
        return leftBarButton
    }
    
    func createUpdateBarButtonItem() -> UIBarButtonItem {
        let leftBarButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(self.saveButtonTapped))
        return leftBarButton
    }
    
    func saveButtonTapped(){
        if isNewNote {
            saveNewNote()
        }
        else{
            updateExistingNote()
        }
    }
    
    func loadExistingNote(){
        txtTitle.text = appDelegate.currentNote?.title
        txtVData.text = appDelegate.currentNote?.data
        self.title = appDelegate.currentNote?.title
    }
    
    func saveNewNote() {
        let id = getNoteId()
        appDelegate.currentNote?.title = txtTitle.text
        appDelegate.currentNote?.data = txtVData.text
        appDelegate.currentNote?.id = String(id)
        let noteImagesFolderPath:URL = (createFolder(name: (appDelegate.currentNote?.id)!, path: appDelegate.noteDataPath).1)!
        moveImagesTempFolderToDestinationFolder(tempFolderPath: appDelegate.tempNoteImagePath, imageFolderPath: noteImagesFolderPath)
        appDelegate.allNotes.append(newElement: appDelegate.currentNote as AnyObject)
        increaseNoteId(id: getNoteId())
        self.navigationController?.popViewController(animated: true)
    }
    
    func moveImagesTempFolderToDestinationFolder(tempFolderPath:URL,imageFolderPath:URL){
        let imageUrls:[URL] = loadListOfFilesFromFolderPath(path: tempFolderPath)
        for tempUrl  in imageUrls{
            if !copyFilesToTheFolder(sourcePath: tempUrl, destinationPath: imageFolderPath){
                //alert
            }
        }
        if !removeFilesFromThePath(path: appDelegate.tempNoteImagePath){
            //alert
        }
    }
    
    func updateExistingNote(){
        appDelegate.currentNote?.data = txtVData.text
        appDelegate.currentNote?.title = txtTitle.text
        appDelegate.allNotes.updateAtIndex(index: noteArrayIndex!, newElement: appDelegate.currentNote! as AnyObject)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imagesButtonClick(_ sender: Any) {
        let obj = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImagesVC") as! ImagesVC
        if !isNewNote{
            obj.isNewNote = false
            obj.imagesFolderPath = appDelegate.noteDataPath.appendingPathComponent((appDelegate.currentNote?.id)!)
        }
        else{
            obj.isNewNote = true
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func locationButtonClick(_ sender: Any) {
        let obj = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        if !isNewNote, let tempLocation = appDelegate.currentNote?.location{
            obj.isNewNote = false
            obj.location = tempLocation
        }
        else {
            obj.isNewNote = true
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //MARK: - Textfield delegates
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        self.title = txtTitle.text
        
        guard txtTitle.text != "" else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("\(self) deinit")
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
