//
//  NSFileManager+CFMDocuments.h
//  ConvenientFileManager
//
//  Created by William Boles on 10/01/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

@import Foundation;

/**
 A collection of helper methods for common operations in the documents directory.
 */
@interface NSFileManager (CFMDocuments)

/**
 Path of documents directory.
 
 return NSString instance.
 */
+ (NSString *)cfm_documentsDirectoryPath;

/**
 Path of resource in documents directory.
 
 @parameter path - path that will be combined documents path.
 
 @return Combined path.
 */
+ (NSString *)cfm_documentsDirectoryPathForResourceWithPath:(NSString *)path;

/**
 Save data to path in document directory.
 
 @parameter data - data to be saved.
 @parameter path - path that will be combined documents path.
 
 @return BOOL if save was successful.
 */
+ (BOOL)cfm_saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path;

/**
 Retrieve data to path in document directory.
 
 @parameter path - path that will be combined documents path.
 
 @return NSData that was retrieved.
 */
+ (NSData *)cfm_retrieveDataFromDocumentsDirectoryWithPath:(NSString *)path;

/**
 Determines if a file exists at path in the document directory
 
 @parameter path - path that will be combined documents path.
 
 @return BOOL - YES if file exists, NO if file doesn't exist.
 */
+ (BOOL)cfm_fileExistsInDocumentsDirectory:(NSString *)path;

/**
 Delete data from path in document directory.
 
 @parameter path - path that will be combined documents path.
 
 @return BOOL if deletion was successful.
 */
+ (BOOL)cfm_deleteDataFromDocumentDirectoryWithPath:(NSString *)path;

@end
