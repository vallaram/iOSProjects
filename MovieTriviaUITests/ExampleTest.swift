//
//  ExampleTest.swift
//  MovieTriviaUITests
//
//  Created by Karteek Vallapuri on 07/09/2019.
//  Copyright © 2019 DonnyWals. All rights reserved.
//
import XCTest

//typealias JSON = [String: Any]

class ExampleTest: XCTestCase {

    var questions: [JSON]?
    
    override func setUp() {
        super.setUp()
        
        guard let filename = Bundle(for: ExampleTest.self).path(forResource: "TriviaQuestions", ofType: "json"),
            let triviaString = try? String(contentsOfFile: filename),
            let triviaData = triviaString.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: triviaData, options: []),
            let triviaJSON = jsonObject as? JSON,
            let jsonQuestions = triviaJSON["questions"] as? [JSON]
            else { return }
        
        questions = jsonQuestions
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments.append("isUITesting")
        app.launch()
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuestionAppears() {
        let app = XCUIApplication()
        
        let buttonIdentifiers = ["AnswerA", "AnswerB", "AnswerC"]
        for identifier in buttonIdentifiers {
            let button = app.buttons.matching(identifier: identifier).element
            let predicate = NSPredicate(format: "exists == true")
            _ = expectation(for: predicate, evaluatedWith: button, handler: nil)
        }
        
        let questionTitle = app.staticTexts.matching(identifier: "QuestionTitle").element
        let predicate = NSPredicate(format: "exists == true")
        _ = expectation(for: predicate, evaluatedWith: questionTitle, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let question = questions?.first
            else { fatalError("Can't continue testing without question data...") }
        
        validateQuestionIsDisplayed(question)
    }

    func validateQuestionIsDisplayed(_ question: JSON) {
        let app = XCUIApplication()
        let questionTitle = app.staticTexts.matching(identifier: "QuestionTitle").element
        
        guard let title = question["title"] as? String,
            let answerA = question["answer_a"] as? String,
            let answerB = question["answer_b"] as? String,
            let answerC = question["answer_c"] as? String
            else { fatalError("Can't continue testing without question data...") }
        
    }
    
}
