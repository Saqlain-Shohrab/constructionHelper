//
//  HomeVM_Test.swift
//  Construction HelperTests
//
//  Created by Saqlain Shohrab on 16/02/2024.
//

import XCTest
import Signals
@testable import Construction_Helper

final class HomeVM_Test: XCTestCase {
    
    private var sut: HomeVM!
    private var mockProjectRepo: ProjectsRepositoryMock!

    override func setUpWithError() throws {
        mockProjectRepo = ProjectsRepositoryMock()
        sut = HomeVM(projectsRepository: mockProjectRepo)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockProjectRepo = nil
        
        try super.tearDownWithError()
    }

    func testApiSuccess() throws {
        mockProjectRepo.dataValue = [ProjectsModelItemView()]
        
        let expectation = XCTestExpectation(description: "Wait")
        sut.onPieCharDataRetrived.subscribe(with: self) { pieCharData in
            XCTAssertNotNil(pieCharData)
            expectation.fulfill()
        }
        
        mockProjectRepo.requestData()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApiFail() throws {
        
        let expectation = XCTestExpectation(description: "Wait")
        sut.onError.subscribe(with: self) { error in
            XCTAssertEqual(error, "Error retriving data")
            expectation.fulfill()
        }
        
        mockProjectRepo.requestData()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testPieChartDataCalculation() throws {
        
        let expectation = XCTestExpectation(description: "Wait")
        sut.onPieCharDataRetrived.subscribe(with: self) { pieCharData in
            XCTAssertNotNil(pieCharData)
            expectation.fulfill()
        }
        
        sut.calculatePieChartData(projects: [ProjectsModelItemView(),ProjectsModelItemView()])
        
        wait(for: [expectation], timeout: 2.0)
    }
    
}
