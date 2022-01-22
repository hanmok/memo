////
////  FolderTest.swift
////  DeeepMemoTests
////
////  Created by Mac mini on 2022/01/05.
////
//
//import XCTest
//@testable import DeeepMemo
//import CoreData
//
//class FolderTests: XCTestCase {
//
//    var controller: PersistenceController!
//
//    var context : NSManagedObjectContext {
//        return controller.container.viewContext
//    }
//    
//    override func setUp() {
//        super.setUp()
//        controller = PersistenceController.empty
//    }
//    
//    override func tearDown() {
//        super.tearDown()
//
//        UnitTestHelpers.deletesAll(container: controller.container)
//    }
//    
//    func testAddFolder() {
//        let folder = Folder(title: "title", context: context)
//        XCTAssertNotNil(folder.id)
//        XCTAssertNotNil(folder.creationDate, "folder needs to have a creation date")
//        
//        XCTAssertTrue(folder.memos.count == 0, "created a folder with no memos")
//        
//        XCTAssertTrue(folder.order == 1, "folder's order should be 1")
//        
//        let folder2 = Folder(title: "second", context: context)
//        XCTAssertTrue(folder2.order == 2, "folder order should be higher than first folder")
//    }
//    
//    func testAddSubfolder() {
//        let parent = Folder(title: "parent", context: context)
//        let child1 = Folder(title: "child1", context: context)
//        let child2 = Folder(title: "child2", context: context)
//        parent.add(subfolder: child1)
//        parent.add(subfolder: child2)
//        XCTAssertTrue(child1.order == 1)
//        XCTAssertTrue(child2.order == 2)
////         add(note: Note, at index: Int32? = nil) {
//    }
//    
//    func testAddNoteToFolder() {
//        let memoTitle = "new"
//        let folder = Folder(title: "new", context: context)
//        let memo = Memo(title: "add me", contents: "testMemo", context: context)
//        
//        memo.folder = folder
//        
//        
//        
//        XCTAssertTrue(memo.folder?.title == memoTitle)
//        XCTAssertNotNil(memo.folder, "note should have been added to a folder" )
////        XCTAssertTrue(folder.notes.first?.title == "new", "the first one should have a name of new")
//        XCTAssertTrue(folder.memos.count == 1, " it only has one note")
//    }
//    
//    func testAddMultipleNotes() {
//        let folder = Folder(title: "new", context: context)
////        let memo1 = Memo(title: "first", context: context)
////        let memo2 = Memo(title: "second", context: context)
//        
//        folder.add(memo: memo1)
//        folder.add(memo: memo2)
//        
//        XCTAssertTrue(folder.memos.count == 2)
//        XCTAssertTrue(folder.memos.sorted().first == memo1)
//        XCTAssertTrue(folder.memos.sorted().last == memo2)
//        
//    }
//    
//    func testAddMemoAtIndex() {
//        let folder = Folder(title: "new", context: context)
////        let memo1 = Memo(title: "first", context: context)
////        let memo2 = Memo(title: "second", context: context)
////        let memo3 = Memo(title: "third", context: context)
//        
//        folder.add(memo: memo1)
//        folder.add(memo: memo2)
//        folder.add(memo: memo3, at: 0)
//        
//        XCTAssertTrue(folder.memos.sorted().first == memo1)
//        XCTAssertTrue(folder.memos.sorted().last == memo2)
//    }
//    
//    func testFetchFolder() {
//        let folder = Folder(title: "new", context: context)
//        
//        let request = Folder.fetch(.all)
//        
//        let result = try? context.fetch(request)
//        
//        XCTAssertTrue(result?.count == 1)
//        
//    }
//    
//    func testTopFolders() {
//        let folder = Folder(title: "new", context: context)
//        let parent = Folder(title: "parent", context: context)
//        folder.parent = parent
//
//        let request = Folder.fetch(.all)
//        let result = try? context.fetch(request)
//        XCTAssertTrue(result?.count == 2)
//
//        let parentFetch = Folder.topFolderFetch()
//        let parents = try? context.fetch(parentFetch)
//        XCTAssertTrue(parents?.count == 1)
//        XCTAssertTrue(parents?.first == parent)
//    }
//    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}
