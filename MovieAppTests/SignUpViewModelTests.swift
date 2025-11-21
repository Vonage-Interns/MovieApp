//
//  SignUpViewModelTests.swift
//  MovieAppTests
//
//  Created by Shreeshailgouda Patil on 19/11/25.
//

import XCTest
import CoreData
@testable import MovieApp

final class SignUpViewModelTests: XCTestCase {
    
    var viewModel: SignUpViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SignUpViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    //Tests for validateInputs
    func testValidateInputs_WhenUsernameIsEmpty() {
        let result = viewModel.validateInputs(username: "", password: "123456", email: "test@mail.com")
        XCTAssertEqual(result, "Username cannot be empty")
    }
    
    func testValidateInputs_WhenEmailIsEmpty() {
        let result = viewModel.validateInputs(username: "user", password: "123456", email: "")
        XCTAssertEqual(result, "Email cannot be empty")
    }
    
    func testValidateInputs_WhenPasswordIsEmpty() {
        let result = viewModel.validateInputs(username: "user", password: "", email: "test@mail.com")
        XCTAssertEqual(result, "Password cannot be empty")
    }
    
    func testValidateInputs_WhenUsernameTooShort() {
        let result = viewModel.validateInputs(username: "abc", password: "123456", email: "test@mail.com")
        XCTAssertEqual(result, "Username and Password must be at least 5 characters long")
    }
    
    func testValidateInputs_WhenPasswordTooShort() {
        let result = viewModel.validateInputs(username: "username", password: "123", email: "test@mail.com")
        XCTAssertEqual(result, "Username and Password must be at least 5 characters long")
    }
    
    func testValidateInputs_WhenEmailInvalid() {
        let result = viewModel.validateInputs(username: "username", password: "123456", email: "invalidemail")
        XCTAssertEqual(result, "Invalid email format")
    }
    
    func testValidateInputs_WhenValidInputs() {
        let result = viewModel.validateInputs(username: "validUser", password: "123456", email: "test@mail.com")
        XCTAssertNil(result)
    }
    
    
    //Tests for registerUser
    func test_registerUser_UserAlreadyExists() {
        let result = viewModel.registerUser(username: "testuser2" , password: "testuser2", email: "testuser2@gmail.com")
        XCTAssertFalse(result)
    }
    
    
    
    







    
    
    

}
