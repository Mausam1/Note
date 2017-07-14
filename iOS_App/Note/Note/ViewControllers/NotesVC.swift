//
//  Notes.swift
//  Note
//
//  Created by Mausam on 7/7/17.
//  Copyright © 2017 Mausam. All rights reserved.
//

import UIKit

class NotesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addBarButtonAction(barButton:)))
        navigationItem.rightBarButtonItem = rightButton
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Notes"
        appDelegate.currentNote = nil
        appDelegate.allNotes.getAll()
        tableView.reloadData()
        DispatchQueue.global().async {
            if !removeFilesFromThePath(path: appDelegate.tempNoteImagePath){
            }
        }
    }
    
    @objc private func addBarButtonAction(barButton:UIBarButtonItem){
        let obj = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewNoteVC") as! NewNoteVC
        obj.isNewNote=true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    // MARK: - TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.allNotes.count()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let tempNote:Note = appDelegate.allNotes[indexPath.row] as! Note
        let tempTitle = tempNote.title
        cell.textLabel?.text = tempTitle
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewNoteVC") as! NewNoteVC
        obj.isNewNote=false
        appDelegate.currentNote = appDelegate.allNotes[indexPath.row] as? Note
        obj.noteArrayIndex = indexPath.row
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            deleteSelectedNote(indexPath: indexPath, tableView: tableView)
        }
    }
    
    private func deleteSelectedNote(indexPath:IndexPath, tableView:UITableView){
        let note = appDelegate.allNotes[indexPath.row] as! Note
        removeFileOrFolderFromPath(path: appDelegate.noteDataPath.appendingPathComponent(note.id))
        appDelegate.allNotes.removeAtIndex(index: indexPath.row)
        tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
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
