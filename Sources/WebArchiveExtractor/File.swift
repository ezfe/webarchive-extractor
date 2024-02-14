//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 2/13/24.
//

import Foundation

enum WAError: Error {
	case urlParseFailed(String)
	case fileExists(String)
}
