//
//  NoteTests.swift
//  NoteTests
//
//  Created by Mausam on 7/7/17.
//  Copyright © 2017 Mausam. All rights reserved.
//

import XCTest
@testable import Note

class NoteTests: XCTestCase {
    
    var allNotes = AllNotesStruct<AnyObject>()
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func checkNoteCounts() {
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        XCTAssertEqual((allNotes.count() == 0), true)
        
        var note = Note()
        note.title = "Note1"
        note.id = "0"
        note.imageNameCount = "0"
        note.location = ""
        note.data = "Note 1 data"
        
        allNotes.append(newElement: note as AnyObject)
        
        XCTAssertEqual((allNotes.count() == 1), true)
        
        note.title = "Note 01"
        allNotes.updateAtIndex(index: 0, newElement: note as AnyObject)
        
        let tempNote = allNotes[0] as! Note
        
        XCTAssertEqual((tempNote.title == "Note1"), false)

        
        allNotes.removeAtIndex(index: 0)
        
        XCTAssertEqual((allNotes.count() == 0), true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
