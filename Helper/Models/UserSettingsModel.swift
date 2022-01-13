//
//  UserSettingsModel.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation

struct UserSettings: Codable {
    let role: String
    var apiRole: String {
        if role == UserRoles.ROLE_CARE_PARTNER.rawValue || role == UserRoles.ROLE_CARE_PARTNER.rawValue {
            return UserRoles.USER_ROLE_CARE_PARTNER.rawValue
        } else {
            return UserRoles.USER_ROLE_PATIENT.rawValue
        }
    }
}
