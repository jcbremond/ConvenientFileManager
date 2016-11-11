//
//  NSFileManagerCFMCacheTests.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class NSFileManagerCFMCacheTests: XCTestCase {
    
    //MARK: Accessors
    
    lazy var dataToBeSaved: Data = {
        let dataToSaved = "Test string to be converted into data".data(using: String.Encoding.utf8)
        
        return dataToSaved!
    }()
    
    lazy var emptyData: Data = {
        let emptyData = "".data(using: String.Encoding.utf8)
        
        return emptyData!
    }()
    
    var testFolder: String = {
        let testFolder = "test"
        
        return testFolder
    }()
    
    lazy var resource: String = {
        let resource = "test.mp4"
        
        return resource
    }()
    
    lazy var resourceWithFolder: String = {
        let resourceWithFolder = "\(self.testFolder)/test.mp4"
        
        return resourceWithFolder
    }()
    
    lazy var cachedDirectoryURL: URL = {
        let cachedDirectoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        
        return cachedDirectoryURL!
    }()
    
    //MARK: TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        if FileManager.fileExists(absolutePath: self.resource) {
            FileManager.deleteData(absolutePath: self.resource)
        }
        
        if FileManager.fileExists(absolutePath: self.resourceWithFolder) {
            FileManager.deleteData(absolutePath: self.resourceWithFolder)
        }
        
        let cacheTestFolder = FileManager.cacheDirectoryPathForResource(relativePath: self.testFolder)
        
        if FileManager.fileExists(absolutePath: cacheTestFolder) {
            FileManager.deleteData(absolutePath: cacheTestFolder)
        }
        
        super.tearDown()
    }
    
    //MARK: Path
    
    func test_cacheDirectoryPath_fullPathToCacheDirectory() {
        let expectedCacheDirectoryPath = self.cachedDirectoryURL.path
        
        let returnedCacheDirectoryPath = FileManager.cacheDirectoryPath()
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResource_fullPathToResource() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path) + "/" + self.resource
        let returnedCacheDirectoryPath = FileManager.cacheDirectoryPathForResource(relativePath: self.resource)
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResource_fullPathToResourceWithFolder() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path) + "/" + self.resourceWithFolder
        let returnedCacheDirectoryPath = FileManager.cacheDirectoryPathForResource(relativePath: self.resourceWithFolder)
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResource_emptyResource() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path)
        let returnedCacheDirectoryPath = FileManager.cacheDirectoryPathForResource(relativePath: "")
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    //MARK: Saving
    
    func test_saveData_fileOnDisk() {
        FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasSaved = FileManager.retrieveDataFromCacheDirectory(relativePath: self.resource)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_successfulSaveReturnValue() {
        let saved = FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_saveData_failedSaveEmptyDataReturnValue() {
        let saved = FileManager.saveDataToCacheDirectory(data: self.emptyData, relativePath: self.resource)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
   
    func test_saveData_failedSaveNilResourceReturnValue() {
        let saved = FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
    
    func test_saveData_fileOnDiskWithFolder() {
        FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasSaved = FileManager.retrieveDataFromCacheDirectory(relativePath: self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)");
    }
    
    //MARK: Retrieval
    
    func test_retrieveDataFromCacheDirectory_dataReturned() {
        FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasRetrieved = FileManager.retrieveDataFromCacheDirectory(relativePath: self.resource)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromCacheDirectory_dataReturnedWithFolder() {
        FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasRetrieved = FileManager.retrieveDataFromCacheDirectory(relativePath: self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromCacheDirectory_emptyDataWithNilResource() {
        let dataThatWasRetrieved = FileManager.retrieveDataFromCacheDirectory(relativePath: "")
        
        XCTAssertNil(dataThatWasRetrieved, "Data should be nil for an empty path parameter")
    }
    
    //MARK: FileExists
    
    func test_fileExistsInCacheDirectory_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let fileExists = FileManager.fileExistsInCacheDirectory(relativePath: resourceThatDoesNotExist)
        
        XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
    }
    
    func test_fileExistsInCacheDirectory_falseReturnValueForEmptyParameter() {
        let fileExists = FileManager.fileExistsInCacheDirectory(relativePath: "")
        
        XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
    }
    
    //MARK: Deleting 
    
    func test_deleteDataFromCacheDirectory_deletesSavedFile() {
        FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        FileManager.deleteDataFromCacheDirectory(relativePath: self.resource)
        
        let fileExists = FileManager.fileExistsInCacheDirectory(relativePath: self.resource)
        
         XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromCacheDirectory_deletesSavedFileReturnValue() {
        FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
       let deleted = FileManager.deleteDataFromCacheDirectory(relativePath: self.resource)
        
        XCTAssertTrue(deleted, "File should not exist as file should have been deleted, this call should be returned as TRUE")
    }
    
    func test_deleteDataFromCacheDirectory_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let deleted = FileManager.deleteDataFromCacheDirectory(relativePath: resourceThatDoesNotExist)
        
        XCTAssertFalse(deleted, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }

    func test_deleteDataFromCacheDirectory_falseReturnValueForEmptyParameter() {
        let deleted = FileManager.deleteDataFromCacheDirectory(relativePath: "")
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource is empty")
    }

    func test_deleteDataFromCacheDirectory_deletesSavedFileWithFolder() {
        FileManager.saveDataToCacheDirectory(data: self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        FileManager.deleteDataFromCacheDirectory(relativePath: self.resourceWithFolder)
        
        let fileExists = FileManager.fileExistsInCacheDirectory(relativePath: self.resourceWithFolder)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }

}
