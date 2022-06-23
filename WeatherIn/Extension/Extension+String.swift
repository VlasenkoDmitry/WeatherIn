//
//  Extension+String.swift
//  WeatherIn
//
//  Created by Ap on 23.06.22.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func shortForApi() -> String {
        switch self {
        case "English":
            return LanguagesApp.English.rawValue
        case "Russian":
            return LanguagesApp.Russian.rawValue
        default:
            return LanguagesApp.English.rawValue
        }
    }
    func firstUppercased() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
