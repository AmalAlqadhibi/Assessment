//
//  UserRowView.swift
//  assessment
//
//  Created by Amal Alqadhibi on 19/02/2024.
//

import Foundation
import SwiftUI

struct UserRowView: View {
     var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(user.name)
                .foregroundColor(.primary)
                .font(.headline)
            HStack(spacing: 3) {
                Text(user.email)
                Spacer()
                Text(user.status)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}
