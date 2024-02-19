//
//  ProjectVM_Test.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 17/02/2024.
//

import XCTest

final class ProjectVM_Test: XCTestCase {
    
    private var sut: ProjectVM!
    private var model: ProjectsModelItemView!
    

    override func setUpWithError() throws {
        model = ProjectsModelItemView()
        sut = ProjectVM(model: model)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        model = nil
        
        try super.tearDownWithError()
    }
    
    func testModifyPDFButtonText_WithProgress() {
        
        let expectation = self.expectation(description: "PDF Button Text Modified")

        sut.modifyPDFButtonText(progress: 0.5)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.pdfButtonText, "Downloaded...50.00 %")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testModifyPDFButtonText_WithTextOnly() {

        let expectation = self.expectation(description: "PDF Button Text Modified")

        sut.modifyPDFButtonText(textOnly: "Test Text")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.pdfButtonText, "Test Text")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
