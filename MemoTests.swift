//
//  DeeepMemoTests.swift
//  DeeepMemoTests
//
//  Created by Mac mini on 2022/01/04.
//

import XCTest
@testable import DeeepMemo
import CoreData

class MemoTests: XCTestCase {

    var controller: PersistenceController!
    
    var context: NSManagedObjectContext {
        return controller.container.viewContext
    }
    
    override func setUp() {
        super.setUp()
        
        controller = PersistenceController.empty
    }
    
//    var context: NSManagedObjectContext {
//        return controller.container.viewContext
//    }
    
    override func tearDown() {
        super.tearDown()
        
        UnitTestHelpers.deletesAll(container: controller.container)
    }
    
    func testAddMemo() {
//        let context = controller.container.viewContext
        let title = "new"
        
        let memo = Memo(title: title, context: context)
        memo.getMemoInfo()

        XCTAssertTrue(memo.title == title)
        XCTAssertNotNil(memo.creationDate, "memo creationDate should not be nil")
        print("testAddMemo has ended")
        
    }
    
    func testUpdateMemo() {
//        let context = controller.container.viewContext
        let memo = Memo(title: "old", context: context)
        memo.title = "new"
        memo.modificationDate = Date(timeIntervalSinceNow: 100)
        memo.getMemoInfo()
        
        XCTAssertTrue(memo.title == "new")
        XCTAssertFalse(memo.title == "old", "memo's title not creectly updated")
        
    }
    
    func testFetchMemos() {
//        let context = controller.container.viewContext
        
        let memo = Memo(title: "fetch me", context: context)
        
        let request = Memo.fetch(.all)
        
        let fetchedMemos = try? context.fetch(request)

        XCTAssertTrue(fetchedMemos!.count == 1, "one fetched")
        XCTAssertTrue(fetchedMemos?.first == memo, "new memo should be fetched")
    }
    
    func testSave() {
        // asynchronous testing
        expectation(forNotification: .NSManagedObjectContextDidSave, object: controller.container.viewContext) { _ in
            return true
        }
        
        controller.container.viewContext.perform {
            let memo = Memo(title: "title", context: self.controller.container.viewContext)
            XCTAssertNotNil(memo, "memo should be there")
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "saving not complete")
        }
    }
    
    func testDeleteMemo() {
//        let context = controller.container.viewContext
        let memo = Memo(title: "memo to delete", context: context)
        
        Memo.delete(memo)
        
        let request = Memo.fetch(NSPredicate.all)
        
        let fetchedMemos = try? context.fetch(request)
        
        XCTAssertTrue(fetchedMemos!.count == 0, "core data fetch should be empty")
        
        XCTAssertFalse(fetchedMemos!.contains(memo), "fetched momos should not contain my deleted memo")
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
