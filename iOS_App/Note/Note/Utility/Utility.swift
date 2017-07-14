//
//  Utility.swift
//  Note
//
//  Created by Mausam on 7/11/17.
//  Copyright © 2017 Mausam. All rights reserved.
//

import Foundation
import UIKit

func increaseNoteId(id:Int){
    UserDefaults.standard.set(id+1, forKey: "noteId")
}

func getNoteId()->Int{
    return UserDefaults.standard.integer(forKey: "noteId")
}


func getDocumentsDirectory() -> URL {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func createFolder(name:String,path:URL) -> (Bool,URL?) {
    
    do {
        let dataPath = path.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: (dataPath.absoluteString)) {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            print("folder has been created  : \(dataPath.absoluteString)\n")
        }
        else{
            print("folder already exists : \(dataPath.absoluteString)\n")
        }
        return (true,dataPath)
    } catch let error as NSError {
        print(error.localizedDescription);
        return (false,nil)
    }
}

func copyFilesToTheFolder(sourcePath:URL,destinationPath:URL)->Bool{
    do{
        let sourceFileData = try Data(contentsOf: sourcePath)
        let finalDestinationPath = destinationPath.appendingPathComponent(sourcePath.lastPathComponent)
        try sourceFileData.write(to: finalDestinationPath, options: .atomicWrite)
        return true
    }
    catch let error as NSError {
        print(error.localizedDescription);
        return false
    }
}

func copyDataToTheFolder(data:Data,fileName:String,destinationPath:URL)->Bool{
    do{
        let finalDestinationPath = destinationPath.appendingPathComponent(fileName)
        try data.write(to: finalDestinationPath, options: .atomicWrite)
        return true
    }
    catch let error as NSError {
        print(error.localizedDescription);
        return false
    }
}


func copyDataToTheFolder(sourcePath:URL,destinationPath:URL)->(Bool,URL?){
    do{
        let sourceFileData = try Data(contentsOf: sourcePath)
        let finalDestinationPath = destinationPath.appendingPathComponent(sourcePath.lastPathComponent)
        try sourceFileData.write(to: finalDestinationPath, options: .atomicWrite)
        return (true,finalDestinationPath)
    }
    catch let error as NSError {
        print(error.localizedDescription);
        return (false,nil)
    }
}


func removeFilesFromThePath(path:URL)->Bool{
    do{
        let arrayFiles = loadListOfFilesFromFolderPath(path: path)
        for url in arrayFiles{
            try fileManager.removeItem(at: url)
        }
        return true
    }
    catch let error as NSError {
        print(error.localizedDescription);
        return false
    }
}

func removeFileOrFolderFromPath(path:URL){
    do{
        try fileManager.removeItem(at: path)
    }
    catch let error as NSError {
        print(error.localizedDescription);
    }
}

func removeFileFromPathAndGetNewList(path:URL)->(Bool,[URL]?){
    do{
        try fileManager.removeItem(at: path)
        var tempPath = path
        tempPath.deleteLastPathComponent()
        return (true,loadListOfFilesFromFolderPath(path: tempPath))
    }
    catch let error as NSError {
        print(error.localizedDescription);
        return (false,nil)
    }
}

func removeFolderFromPath(path:URL){
    
}

func loadListOfFilesFromFolderPath(path:URL)->[URL]{
    var urls : [NSURL] = []
    let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: path.path)!
    while let element = enumerator.nextObject() as? String {
        urls.append(path.appendingPathComponent(element) as NSURL)
    }
    return urls as Array<URL>
}
