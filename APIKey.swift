//
//  APIKey.swift
//  Turn2
//
//  Created by Srishti Sahi on 25/07/24.
//

import Foundation

enum APIKey {
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "API_KEY") as? String, !value.isEmpty else {
            fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist' or the key is empty.")
        }
        return value
    }
}
