//
//  KeychainHelper.swift
//  assessment
//
//  Created by Amal Alqadhibi on 20/02/2024.
//

import Foundation
import Security

public enum appError: Error {
    case keychainError
    case HTTPError
    
}
class KeychainHelper {

    
    private static let kKeychainAccountService = "kpasswordKey"
    
    
    static func savePassword(for key: String, password: String) throws {
        let passwordData = password.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: kKeychainAccountService,
            kSecAttrAccount as String: key,
            kSecValueData as String: passwordData
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard  status == errSecSuccess else {
            print("Failed to save password in keychain \(status)")
            throw appError.keychainError
        }
    }
    
    static func getPassword(for key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: kKeychainAccountService,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var passwordData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &passwordData)
        
        guard status == errSecSuccess, let retrievedData = passwordData as? Data else {
            print("Failed to retrieve password \(status)")
            throw appError.keychainError
        }
        
        let password = String(data: retrievedData, encoding: .utf8)
        return password
    }
    
    static func deletePassword(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: kKeychainAccountService,
            kSecAttrAccount as String: key
        ]
        
        let statusCode = SecItemDelete(query as CFDictionary)
        
        guard statusCode == errSecSuccess else {
            print("Failed to delete password. Status code: \(statusCode)")
            throw appError.keychainError
        }
    }
}
