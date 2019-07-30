import XCTest
@testable import Notes

class TestFileNotebook: XCTestCase {
    
    let testNote = Note(
        uid: "12121212",
        title: "My_title",
        content: "contetetetete",
        importance: Importance.important
    )

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAdd() {
        let notes = FileNotebook.init()
        notes.add(self.testNote)
        XCTAssertTrue(notes.containsNote(self.testNote))
    }
    
    func testRemove() {
        let notes = FileNotebook.init()
        let uuid: String = self.testNote.uid
        notes.add(self.testNote)
        notes.remove(with: uuid)
        XCTAssertFalse(notes.containsNote(self.testNote))
    }
    
    func testLoadFromFile() {
        let notes = FileNotebook.init()
        notes.add(self.testNote)
        notes.saveToFile()
        notes.loadFromFile()
        XCTAssertTrue(notes.containsNote(self.testNote))
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
