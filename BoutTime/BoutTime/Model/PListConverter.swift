//
//  PListConverter.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

// MARK: - Enum
//**********************************************************************
/// An enum representing the errors that can be thrown from the PListConverter class.
enum PListError : Error {
    case invalidResource
    case conversionFailure
}

// MARK: - PListConverter
//**********************************************************************
/// This class contains one static method that accepts a String, representing the file name of a plist, and that returns a dictionary of String keys mapped to AnyObject values. The method can throw an error if the plist name is not valid or if the plist fails to convert to the required dictionary.
class PListConverter {
    
    static func createDictionaryFromPList(inFile name: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else {
            throw PListError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw PListError.conversionFailure
        }
        
        return dictionary
    }
    
}
