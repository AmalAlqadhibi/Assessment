//
//  User.swift
//  assessment
//
//  Created by Amal Alqadhibi on 19/02/2024.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let status: String
    
    init(entity: UserEntity) {
        id = Int(entity.id)
        name = entity.name ?? ""
        email = entity.email ?? ""
        status = entity.status ?? ""
    }
}
