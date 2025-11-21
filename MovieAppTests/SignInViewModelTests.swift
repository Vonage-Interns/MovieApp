//
//  SignInViewModelTests.swift
//  MovieAppTests
//
//  Created by Shreeshailgouda Patil on 19/11/25.
//

import XCTest
@testable import MovieApp

final class SignInViewModelTests: XCTestCase {
    
    var viewModel: SignInViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        // Arrange
        viewModel = SignInViewModel() // new ViewModel for each test
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown() // release memory / clean state
        
    }
    
    func test_validateUser_WhenUserDoesNotExist(){
        //Act
        let validateUser = viewModel.validateUser(email: "example@gmail.com", password: "123456789")
        // Assert   
        XCTAssertFalse(validateUser)
    }
    
    func test_validateUser_WhenUserDoesExist(){
        let validateUser = viewModel.validateUser(email: "testuser2@gmail.com", password: "testuser2")
        XCTAssertTrue(validateUser)
    }
    
    func test_FetchUsername_NoUserFound() {
        let username = viewModel.fetchUsername(forEmail: "unknownuser@gmail.com")
        XCTAssertNil(username)
    }
    
    func test_FetchUsername_Found() {
        let username = viewModel.fetchUsername(forEmail: "testuser2@gmail.com")
        XCTAssertNotNil(username)
    }
    
    func test_FetchUserID_NoUserFound() {
        let result = viewModel.fetchUserID(forEmail: "notfound@mail.com")
        XCTAssertNil(result)
    }
    
    func test_FetchUserID_UserFound() {
        let result = viewModel.fetchUserID(forEmail: "testuser2@mail.com")
        XCTAssertNil(result)
    }
    
}
