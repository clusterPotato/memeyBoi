//
//  memeError.swift
//  Memey Boi
//
//  Created by Gavin Craft on 5/5/21.
//

import Foundation
enum MemeError: LocalizedError{
    case unidentified
    case unknownURL
    case badData
    case cannotParse
    var errorDescription: String?{
        switch self{
        case .unidentified:
            return "http error"
        case .unknownURL:
            return "bad url"
        case .badData:
            return "bad data"
        case .cannotParse:
            return "error parsing"
        }
    }
}
