//
//  PListConverter.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

enum PListError {
    case invalidResource
    case conversionFailure
}

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
