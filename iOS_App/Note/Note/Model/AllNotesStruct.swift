//
//  AllNotesStruct.swift
//  Note
//
//  Created by Mausam on 7/10/17.
//  Copyright © 2017 Mausam. All rights reserved.
//

import Foundation
import CoreData

struct AllNotesStruct<T> {
    var array:[T] = []
    
    mutating func append(newElement: T) {
        saveIt(element:newElement)
        self.array.append(newElement)
        print("Element added")
    }
    
    mutating func removeAtIndex(index: Int) {
        print("Removed object \(self.array[index]) at index \(index)")
        removeIt(element: self.array[index])
        self.array.remove(at: index)
    }
    
    mutating func updateAtIndex(index:Int, newElement:T){
        updateIt(element: newElement)
        self.array[index] = newElement
    }
    
    mutating func removeAll() {
        print("Removed all")
        removeAllData()
        if self.array.count > 0{
            self.array.removeAll()
        }
        //removeIt(element:)
    }
    
    mutating func getObject(i:Int)->T{
        return array[i]
    }
    
    mutating func setObject(obj:T, index i:Int){
        updateIt(element: obj)
        array[i] = obj
    }
    
    mutating func count()->Int{
        return self.array.count
    }
    
    mutating func getAll(){
        if array.count > 0 {
            self.array.removeAll()
        }
        
        let fetchRequest: NSFetchRequest<NoteData> = NoteData.fetchRequest()
        do {
            
            let noteData = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            for tempNote in noteData {
                var note = Note()
                note.title = tempNote.title
                note.data = tempNote.data
                note.id =  tempNote.id
                note.location = tempNote.location
                note.imageNameCount = tempNote.imageNameCount
                self.array.append(note as! T)
            }
        }
        catch {
            print("Error with request: \(error)")
        }
        
    }
    
    func saveIt(element:T){
        let noteData = NoteData(context:context)
        if let tempNote = element as? Note{
            noteData.id = tempNote.id
            noteData.title = tempNote.title
            noteData.location = tempNote.location
            noteData.data = tempNote.data
            noteData.imageNameCount = tempNote.imageNameCount
            appDelegate.saveContext()
        }
    }
    
    func updateIt(element:T){
        if let tempNote = element as? Note{
            let fetchRequest: NSFetchRequest<NoteData> = NoteData.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "id== %@",tempNote.id)
            if let result = try? context.fetch(fetchRequest) {
                let noteData = result[0]
                noteData.data = tempNote.data
                noteData.imageNameCount = tempNote.imageNameCount
                noteData.location = tempNote.location
                noteData.title = tempNote.title
                appDelegate.saveContext()
            }
        }
    }
    
    func removeIt(element:T){
        if let tempNote = element as? Note{
            let fetchRequest: NSFetchRequest<NoteData> = NoteData.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "id== %@",tempNote.id)
            if let result = try? context.fetch(fetchRequest) {
                context.delete(result[0] )
                appDelegate.saveContext()
            }
        }
    }
    
    func removeAllData() {
        do {
            let result = try context.fetch(NoteData.fetchRequest())
            for noteData in result as! [NoteData]{
                context.delete(noteData)
                appDelegate.saveContext()
            }
            
        } catch  {
            print(error)
        }
    }
    
    init() {
        //  getAll()
    }
    
    subscript(index: Int) -> T {
        set {
            print("Set object from \(self.array[index]) to \(newValue) at index \(index)")
            self.array[index] = newValue
        }
        get {
            return self.array[index]
        }
    }
}
