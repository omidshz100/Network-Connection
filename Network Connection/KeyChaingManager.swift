//
//  KeyChaingManager.swift
//  Network Connection
//
//  Created by Omid Shojaeian Zanjani on 23/08/24.
//

import Foundation
import Security


class KeychainService {
    static let shared = KeychainService()
    
    func saveAPIKey(_ key: String, for service: String) {
        guard let data = key.data(using: .utf8) else { return }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemAdd(query, nil)
    }
    
    func retrieveAPIKey(for service: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
    
    func deleteAPIKey(for service: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    func test(){
        // Usage example
        KeychainService.shared.saveAPIKey("your_api_key", for: "com.example.yourapp.apikey")
        let apiKey = KeychainService.shared.retrieveAPIKey(for: "com.example.yourapp.apikey")
        print(apiKey)
    }
}

